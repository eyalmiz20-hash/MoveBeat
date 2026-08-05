# Launches the Kinect applications at logon, once the sensor is actually ready.
#
# Why this waits instead of just launching: at logon the KinectMonitor service
# is still starting and the sensor is still enumerating on USB. Anything
# launched immediately loses that race and simply reports "Kinect not found".
# So we poll the PnP device until it reports OK, then start the apps.
#
# Installed by install-kinect-autostart.ps1 (a Startup-folder shortcut, no
# admin needed); launched with no console flash via run-kinect-autostart.vbs.
#
# To change what starts, edit the $Apps list below, commit, and push -- the
# auto-updater will deliver it to this machine.

$ErrorActionPreference = 'Continue'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$LogDir   = Join-Path $RepoRoot 'tools\logs'
$LogFile  = Join-Path $LogDir 'kinect-autostart.log'
$KinectSdk = 'C:\Program Files\Microsoft SDKs\Kinect\v2.0_1409'

# Apps to launch, in order. StaggerSeconds is the pause AFTER launching each
# one, so they don't all hit the sensor at the same instant.
$Apps = @(
    @{ Name = 'MoveBeat';       Path = (Join-Path $RepoRoot 'MoveBeat\bin\Debug\net48\MoveBeat.exe');        Stagger = 3 }
    @{ Name = 'Body Basics';    Path = (Join-Path $KinectSdk 'bin\BodyBasics-D2D.exe');                      Stagger = 3 }
    @{ Name = 'Kinect Studio';  Path = (Join-Path $KinectSdk 'Tools\KinectStudio\KStudio.exe');              Stagger = 0 }
)

$SensorWaitSeconds = 90

if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir -Force | Out-Null }

function Write-Log {
    param([string]$Message)
    $line = '[{0}] {1}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Message
    Add-Content -Path $LogFile -Value $line
    Write-Host $line
    try {
        $item = Get-Item $LogFile -ErrorAction SilentlyContinue
        if ($item -and $item.Length -gt 1MB) {
            $lines = Get-Content $LogFile
            $keep = [Math]::Max(1, [Math]::Floor($lines.Count / 2))
            $lines[($lines.Count - $keep)..($lines.Count - 1)] | Set-Content $LogFile
        }
    } catch { }
}

# Single-instance guard - a second logon trigger must not double-launch.
$mutex = New-Object System.Threading.Mutex($false, 'MoveBeatKinectAutostartMutex')
$gotMutex = $false
try { $gotMutex = $mutex.WaitOne(0) }
catch [System.Threading.AbandonedMutexException] { $gotMutex = $true }
if (-not $gotMutex) {
    Write-Log 'Another kinect-autostart instance is already running - exiting.'
    exit 0
}

Write-Log '===================================================================='
Write-Log "kinect-autostart starting. PID=$PID"

# --- wait for the sensor -----------------------------------------------------
Write-Log "Waiting up to $SensorWaitSeconds s for the Kinect to report ready..."
$deadline = (Get-Date).AddSeconds($SensorWaitSeconds)
$sensorReady = $false
while ((Get-Date) -lt $deadline) {
    $svc = Get-Service KinectMonitor -ErrorAction SilentlyContinue
    $dev = Get-PnpDevice -ErrorAction SilentlyContinue |
           Where-Object { $_.FriendlyName -like '*Xbox NUI Sensor*' -or $_.Class -eq 'KinectSensor' }
    $devOk = $false
    if ($dev) { foreach ($d in @($dev)) { if ($d.Status -eq 'OK') { $devOk = $true } } }

    if ($svc -and $svc.Status -eq 'Running' -and $devOk) { $sensorReady = $true; break }
    Start-Sleep -Seconds 3
}

if ($sensorReady) {
    Write-Log 'Kinect reports ready.'
    # The device reporting OK precedes the sensor actually streaming by a
    # moment; give it a beat before the first client attaches.
    Start-Sleep -Seconds 5
}
else {
    Write-Log 'WARNING: Kinect did not report ready in time. Launching anyway - the apps will show their own error if the sensor is genuinely missing.'
}

# --- launch ------------------------------------------------------------------
foreach ($app in $Apps) {
    $name = $app.Name
    $path = $app.Path

    if (-not (Test-Path $path)) {
        Write-Log "SKIP ${name}: not found at $path"
        continue
    }

    $procName = [IO.Path]::GetFileNameWithoutExtension($path)
    if (Get-Process -Name $procName -ErrorAction SilentlyContinue) {
        Write-Log "SKIP ${name}: already running."
        continue
    }

    try {
        # No -NoNewWindow: these need their own visible window on the user's
        # desktop, and this script itself runs hidden.
        Start-Process -FilePath $path -WorkingDirectory (Split-Path $path)
        Write-Log "Launched ${name}."
    }
    catch {
        Write-Log ("FAILED to launch ${name}: " + $_.Exception.Message)
    }

    if ($app.Stagger -gt 0) { Start-Sleep -Seconds $app.Stagger }
}

Write-Log 'kinect-autostart done.'
