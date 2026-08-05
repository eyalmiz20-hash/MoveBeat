# MoveBeat auto-updater poller.
#
# One long-lived process that polls GitHub every ~30s. When origin/main has
# moved, it kills the running MoveBeat.exe (file lock), mirrors the working
# tree to origin/main (force-reset - this PC never keeps local edits),
# rebuilds, and relaunches. Runs hidden via tools/run-hidden.vbs, registered
# by tools/install-task.ps1.
#
# Trade-off: this only runs while the user is logged on, and stops at
# logoff - the correct trade for a desktop app needing a visible window and
# USB (Kinect) access. Session 0 ("run whether logged on or not") is off the
# table for that reason.

$ErrorActionPreference = 'Continue'

# ---------------------------------------------------------------------------
# Paths - resolved relative to this script's own location so the script
# stays correct if the clone ever moves, except for OS-level absolute paths
# (dotnet.exe) which are fixed regardless of repo location.
# ---------------------------------------------------------------------------
$RepoRoot  = Split-Path -Parent $PSScriptRoot
$Csproj    = Join-Path $RepoRoot 'MoveBeat\MoveBeat.csproj'
$ExePath   = Join-Path $RepoRoot 'MoveBeat\bin\Debug\net48\MoveBeat.exe'
$DotnetExe = 'C:\Program Files\dotnet\dotnet.exe'
$LogDir    = Join-Path $RepoRoot 'tools\logs'
$LogFile   = Join-Path $LogDir 'sync.log'
$MaxLogBytes = 2MB

$PollIntervalSeconds = 30
$BackoffSteps = @(60, 120, 300)   # applied after 1st, 2nd, 3rd+ consecutive failures

if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

# Runs git and returns its combined output as plain text.
#
# Why this exists: in Windows PowerShell 5.1, "2>&1" on a NATIVE command wraps
# each stderr line in an ErrorRecord, so piping it to Out-String renders a
# NativeCommandError stack trace into the log - even on complete success,
# because git writes ordinary progress ("From https://github.com/...") to
# stderr. That noise would bury the real message on an actual failure.
# Unwrapping the ErrorRecords here keeps the log readable.
function Invoke-Git {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$GitArgs)

    $prev = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    try {
        $raw = & git @GitArgs 2>&1
        $script:GitExitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $prev
    }

    $lines = @($raw | ForEach-Object {
        if ($_ -is [System.Management.Automation.ErrorRecord]) { $_.Exception.Message } else { [string]$_ }
    })
    return (($lines -join "`n").Trim())
}

function Write-Log {
    param([string]$Message)
    $line = '[{0}] {1}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Message
    Add-Content -Path $LogFile -Value $line
    Write-Host $line

    try {
        $item = Get-Item -Path $LogFile -ErrorAction SilentlyContinue
        if ($item -and $item.Length -gt $MaxLogBytes) {
            $lines = Get-Content -Path $LogFile
            $keep = [Math]::Floor($lines.Count / 2)
            if ($keep -lt 1) { $keep = 1 }
            $start = $lines.Count - $keep
            $lines[$start..($lines.Count - 1)] | Set-Content -Path $LogFile
        }
    }
    catch {
        # Trimming is best-effort - never let a log-housekeeping failure kill the loop.
    }
}

# ---------------------------------------------------------------------------
# Single-instance guard. A logon re-trigger (or a manual re-run while the
# scheduled task copy is already up) must never spawn a second poller.
# ---------------------------------------------------------------------------
$mutex = New-Object System.Threading.Mutex($false, 'MoveBeatSyncLoopMutex')
$gotMutex = $false
try {
    $gotMutex = $mutex.WaitOne(0)
}
catch [System.Threading.AbandonedMutexException] {
    # A previous instance died without releasing it - we still own it now.
    $gotMutex = $true
}

if (-not $gotMutex) {
    Write-Log 'Another sync-loop instance already holds the mutex - exiting.'
    exit 0
}

# ---------------------------------------------------------------------------
# Neutralise any chance of a credential prompt hanging the loop forever.
# The repo is public, so these should never actually be needed - this is a
# safety net for unattended operation.
# ---------------------------------------------------------------------------
$env:GIT_TERMINAL_PROMPT = '0'
$env:GCM_INTERACTIVE     = 'never'
$env:GIT_ASKPASS         = ''

Write-Log '===================================================================='
Write-Log ("sync-loop starting. RepoRoot=$RepoRoot PID=$PID")
Write-Log 'Trade-off: this poller runs only while the user is logged on; it stops at logoff.'

if (-not (Test-Path (Join-Path $RepoRoot '.git'))) {
    Write-Log "FATAL: $RepoRoot does not look like a git repo (no .git folder). Exiting."
    exit 1
}

Set-Location $RepoRoot

# Let KinectMonitor, USB enumeration and the network settle after logon
# before the first check (the scheduled task trigger also has its own
# 30s delay - this is a second, independent buffer).
Write-Log "Startup settle delay: sleeping $PollIntervalSeconds s before first check."
Start-Sleep -Seconds $PollIntervalSeconds

$consecutiveFailures = 0

while ($true) {
    try {
        $localSha = Invoke-Git rev-parse HEAD
        $remoteLine = Invoke-Git ls-remote origin refs/heads/main
        $remoteSha = ($remoteLine -split '\s+')[0]

        if ($localSha.Length -ne 40) {
            throw "git rev-parse HEAD returned unexpected output: '$localSha'"
        }

        if ([string]::IsNullOrWhiteSpace($remoteSha) -or $remoteSha.Length -ne 40) {
            throw "git ls-remote returned unexpected output: '$remoteLine'"
        }

        if ($remoteSha -eq $localSha) {
            Write-Log ("No change (HEAD={0})." -f $localSha.Substring(0, 7))
            $consecutiveFailures = 0
        }
        else {
            Write-Log ("Change detected: local {0} -> remote {1}" -f $localSha.Substring(0, 7), $remoteSha.Substring(0, 7))

            # 1. Kill MoveBeat.exe BEFORE building - a running exe holds a
            #    lock on the output file and the build fails with MSB3021.
            #    Order is kill -> wait -> build -> relaunch, never build-then-kill.
            $running = Get-Process -Name MoveBeat -ErrorAction SilentlyContinue
            if ($running) {
                Write-Log 'Stopping running MoveBeat.exe before build...'
                $running | Stop-Process -Force
                $running | Wait-Process -Timeout 10 -ErrorAction SilentlyContinue
            }
            # Stop-Process -Force is a hard terminate, so sensor.Close() never
            # runs - KinectMonitor can still hold the sensor handle briefly.
            # Relaunching too fast produces "Kinect not found".
            Start-Sleep -Seconds 2

            # 2. Mirror to origin/main. Pin it explicitly - a stale
            #    refs/heads/master still exists on the remote and must never
            #    be resolved by accident. No git clean: bin/obj are
            #    gitignored, so reset won't touch them - keep them for fast
            #    incremental builds.
            $fetchOut = Invoke-Git fetch origin main
            Write-Log ("git fetch: " + $fetchOut)

            $resetOut = Invoke-Git reset --hard origin/main
            Write-Log ("git reset: " + $resetOut)

            $newSha = Invoke-Git rev-parse HEAD
            Write-Log ("Now at {0}." -f $newSha.Substring(0, 7))

            # 3. Build - absolute dotnet path (a scheduled task's PATH may
            #    differ from a shell's), explicit csproj (no root .sln).
            Write-Log 'Building...'
            $buildOut = ((& $DotnetExe build $Csproj -c Debug -v minimal --nologo 2>&1) | Out-String)
            $buildExit = $LASTEXITCODE

            if ($buildExit -ne 0) {
                Write-Log ("BUILD FAILED (exit $buildExit). Leaving the last working exe in place, skipping relaunch.")
                Write-Log ("Build output:`n" + $buildOut.Trim())
                $consecutiveFailures++
            }
            else {
                Write-Log 'Build succeeded.'

                if (Test-Path $ExePath) {
                    # No -NoNewWindow: default Start-Process allocates its
                    # own fresh, visible console even though the poller's
                    # own console is hidden. With -NoNewWindow the child
                    # inherits the hidden console, all output vanishes, and
                    # Console.Clear()/SetCursorPosition throw IOException.
                    Start-Process -FilePath $ExePath -WorkingDirectory (Split-Path $ExePath)
                    Write-Log 'Relaunched MoveBeat.exe.'
                }
                else {
                    Write-Log "WARNING: build reported success but $ExePath was not found - not relaunching."
                }

                # tools/ lives in the repo, so a pull can overwrite this very
                # script. PowerShell reads the whole file into memory at
                # launch, so this running instance is unaffected - flag it
                # clearly instead of silently doing nothing.
                $toolsChanged = Invoke-Git diff --name-only $localSha $newSha -- tools
                if ($toolsChanged.Length -gt 0) {
                    Write-Log 'NOTE: tools/ changed in this pull - this poller script was updated on disk, but the running instance still holds the old copy in memory. To apply: log off and back on, or run tools\uninstall-startup.ps1 then relaunch tools\run-hidden.vbs.'
                }

                $consecutiveFailures = 0
            }
        }
    }
    catch {
        $consecutiveFailures++
        Write-Log ("ERROR in sync cycle: " + $_.Exception.Message)
    }

    if ($consecutiveFailures -eq 0) {
        $sleepSeconds = $PollIntervalSeconds
    }
    else {
        $idx = [Math]::Min($consecutiveFailures - 1, $BackoffSteps.Length - 1)
        $sleepSeconds = $BackoffSteps[$idx]
        Write-Log ("Backing off: sleeping $sleepSeconds s (consecutive failures = $consecutiveFailures).")
    }

    Start-Sleep -Seconds $sleepSeconds
}
