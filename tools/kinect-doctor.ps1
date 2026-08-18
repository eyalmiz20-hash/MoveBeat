# MoveBeat Kinect doctor - finds out WHY the Kinect app keeps dying.
#
# ---------------------------------------------------------------------------
# WHY THIS IS A SEPARATE PROCESS
#
# A process cannot report its own crash. MoveBeat.exe logs what it can, but
# the interesting moment is the one where it stops existing - and whatever is
# still running at that instant is the only thing that can describe it. So
# this watchdog deliberately outlives the app it watches: it samples the
# process, the sensor device, the Kinect service and the Windows event log,
# and reports every transition.
#
# WHY IT TALKS OVER UDP
#
# Development happens on the Mac and the PC is often unattended, so a report
# written only to a file on the PC is a report nobody reads. This broadcasts
# every line to the Mac over the same wired-Ethernet path the joint stream
# already uses (port 7401, NOT the 7400 music port), where
# tools/mac/kinect-doctor-listen.py prints it live. It also writes everything
# to tools/logs/kinect-doctor.log, so nothing is lost if the Mac is off.
#
# HOW IT GETS STARTED
#
# MoveBeat.exe spawns it at startup (see Program.StartDoctor). That is the
# only activation path that needs nobody at the PC: a git push rebuilds and
# relaunches the exe, and the exe starts this. A single-instance mutex means
# the repeated relaunches of a crash loop still only ever produce one doctor.
# It can also be run by hand, and -Once gives a one-shot snapshot.
# ---------------------------------------------------------------------------

param(
    # Explicit destination for the report. Default: the wired-Ethernet subnet
    # broadcast, matching OscSender.ResolveBroadcastAddress().
    [string]$Ip,

    # Deliberately NOT 7400 - that port carries the joint stream into Max and
    # must not be polluted with diagnostics.
    [int]$Port = 7401,

    # Take one snapshot and exit, instead of watching continuously.
    [switch]$Once,

    [int]$IntervalSeconds = 2
)

$ErrorActionPreference = 'Continue'

$RepoRoot  = Split-Path -Parent $PSScriptRoot
$LogDir    = Join-Path $RepoRoot 'tools\logs'
$LogFile   = Join-Path $LogDir 'kinect-doctor.log'
$MoveBeatLog = Join-Path $LogDir 'movebeat.log'
$SyncLog   = Join-Path $LogDir 'sync.log'
$KinectSdk = 'C:\Program Files\Microsoft SDKs\Kinect\v2.0_1409'
$MaxLogBytes = 4MB

# A UDP datagram must stay under the ~1472-byte non-fragmenting limit.
$MaxPayload = 1200

if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir -Force | Out-Null }

# ---------------------------------------------------------------------------
# Transport
# ---------------------------------------------------------------------------

# Mirrors OscSender.ResolveBroadcastAddress(): wired Ethernet only, skipping
# APIPA. The PC sits on Ethernet 192.168.0.x and Wi-Fi 192.168.8.x at once, and
# picking whichever enumerated first was non-deterministic.
function Resolve-BroadcastAddress {
    try {
        $adapters = Get-NetAdapter -Physical -ErrorAction SilentlyContinue |
                    Where-Object { $_.Status -eq 'Up' -and $_.MediaType -eq '802.3' }

        foreach ($a in @($adapters)) {
            $addrs = Get-NetIPAddress -InterfaceIndex $a.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue
            foreach ($addr in @($addrs)) {
                $ipStr = $addr.IPAddress
                if ($ipStr -like '169.254.*') { continue }   # APIPA reaches nothing
                if ($ipStr -eq '127.0.0.1')   { continue }

                $prefix = [int]$addr.PrefixLength
                if ($prefix -le 0 -or $prefix -gt 32) { continue }

                $ipBytes = ([System.Net.IPAddress]::Parse($ipStr)).GetAddressBytes()
                $maskInt = if ($prefix -eq 0) { 0 } else { [uint32]0xFFFFFFFF -shl (32 - $prefix) }
                $maskBytes = @(
                    [byte](($maskInt -shr 24) -band 0xFF),
                    [byte](($maskInt -shr 16) -band 0xFF),
                    [byte](($maskInt -shr 8)  -band 0xFF),
                    [byte]( $maskInt          -band 0xFF)
                )
                $bc = New-Object byte[] 4
                for ($i = 0; $i -lt 4; $i++) {
                    $bc[$i] = [byte](($ipBytes[$i] -bor (-bnot $maskBytes[$i])) -band 0xFF)
                }
                return (New-Object System.Net.IPAddress(,$bc)).ToString()
            }
        }
    }
    catch { }

    return '255.255.255.255'
}

if ([string]::IsNullOrWhiteSpace($Ip)) { $Ip = Resolve-BroadcastAddress }

$script:Udp = $null
try {
    $script:Udp = New-Object System.Net.Sockets.UdpClient
    $script:Udp.EnableBroadcast = $true
}
catch {
    $script:Udp = $null
}
$script:Endpoint = New-Object System.Net.IPEndPoint ([System.Net.IPAddress]::Parse($Ip)), $Port
$script:Host     = $env:COMPUTERNAME

# Writes one line to the log and broadcasts it to the Mac. Never throws: a
# diagnostic that can fail loudly is worse than no diagnostic.
function Emit {
    param([string]$Kind, [string]$Text)

    $stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $line  = "[{0}] {1,-9} {2}" -f $stamp, $Kind, $Text

    try {
        Add-Content -Path $LogFile -Value $line
        $item = Get-Item -Path $LogFile -ErrorAction SilentlyContinue
        if ($item -and $item.Length -gt $MaxLogBytes) {
            $lines = Get-Content -Path $LogFile
            $keep = [Math]::Max(1, [Math]::Floor($lines.Count / 2))
            $lines[($lines.Count - $keep)..($lines.Count - 1)] | Set-Content -Path $LogFile
        }
    }
    catch { }

    Write-Host $line

    if ($null -ne $script:Udp) {
        try {
            $wire = "MBDOC|{0}|{1}|{2}|{3}" -f $script:Host, $stamp, $Kind, $Text
            $bytes = [Text.Encoding]::UTF8.GetBytes($wire)
            if ($bytes.Length -gt $MaxPayload) {
                $bytes = $bytes[0..($MaxPayload - 1)]
            }
            [void]$script:Udp.Send($bytes, $bytes.Length, $script:Endpoint)
        }
        catch { }
    }
}

# Sends a multi-line block one datagram per line, so nothing is silently
# truncated by the MTU.
function Emit-Block {
    param([string]$Kind, [string]$Title, [string[]]$Lines)
    Emit $Kind ("--- " + $Title + " ---")
    foreach ($l in @($Lines)) {
        if ($null -eq $l) { continue }
        $t = ([string]$l).TrimEnd()
        if ($t.Length -eq 0) { continue }
        Emit $Kind ("  " + $t)
    }
}

# ---------------------------------------------------------------------------
# Probes
# ---------------------------------------------------------------------------

function Get-KinectDevice {
    try {
        $dev = Get-PnpDevice -ErrorAction SilentlyContinue |
               Where-Object { $_.FriendlyName -like '*Xbox NUI Sensor*' -or $_.Class -eq 'KinectSensor' }
        return @($dev)
    }
    catch { return @() }
}

function Get-DeviceSummary {
    $devs = Get-KinectDevice
    if ($devs.Count -eq 0) { return 'ABSENT' }
    $parts = @()
    foreach ($d in $devs) { $parts += ("{0}={1}" -f $d.FriendlyName, $d.Status) }
    return ($parts -join '; ')
}

function Get-ServiceStatus {
    param([string]$Name)
    try {
        $svc = Get-Service $Name -ErrorAction SilentlyContinue
        if ($null -eq $svc) { return 'MISSING' }
        return [string]$svc.Status
    }
    catch { return 'ERROR' }
}

function Get-MoveBeatProcesses {
    try { return @(Get-Process -Name MoveBeat -ErrorAction SilentlyContinue) }
    catch { return @() }
}

function Get-PowerSummary {
    $out = @()
    try {
        $batt = Get-WmiObject -Class Win32_Battery -ErrorAction SilentlyContinue
        if ($batt) {
            foreach ($b in @($batt)) {
                # BatteryStatus 2 == running on AC.
                $onAc = ($b.BatteryStatus -eq 2)
                $out += ("Battery present. OnAC={0} Charge={1}%" -f $onAc, $b.EstimatedChargeRemaining)
            }
        }
        else {
            $out += 'No battery reported (desktop, or WMI unavailable).'
        }
    }
    catch { $out += 'Battery query failed.' }

    # USB selective suspend is a classic cause of a Kinect that drops on a
    # cycle: Windows powers the hub down and the sensor re-enumerates.
    try {
        $usbSub = '2a737441-1930-4402-8d77-b2bebba308a3'
        $raw = & powercfg /q SCHEME_CURRENT $usbSub 2>&1 | Out-String
        foreach ($l in ($raw -split "`n")) {
            if ($l -match 'Setting|Index|selective|Suspend') { $out += $l.Trim() }
        }
    }
    catch { $out += 'powercfg query failed.' }

    return $out
}

# Windows records an app crash in the Application log. This is the single most
# valuable piece of evidence for "it died and I do not know why", and it is
# exactly what cannot be seen from the Mac.
function Get-CrashEvents {
    param([DateTime]$Since, [int]$Max = 12)

    $results = @()
    try {
        $ev = Get-WinEvent -FilterHashtable @{
            LogName   = 'Application'
            StartTime = $Since
        } -MaxEvents 200 -ErrorAction SilentlyContinue

        foreach ($e in @($ev)) {
            $p = [string]$e.ProviderName
            if ($p -notmatch 'Application Error|\.NET Runtime|Windows Error Reporting|Application Hang') { continue }
            $msg = ([string]$e.Message) -replace '\s+', ' '
            if ($msg.Length -gt 600) { $msg = $msg.Substring(0, 600) + '...' }
            $results += ("{0} [{1}] {2}" -f $e.TimeCreated.ToString('HH:mm:ss'), $p, $msg)
            if ($results.Count -ge $Max) { break }
        }
    }
    catch { }
    return $results
}

# Device re-enumeration and service restarts land in the System log. If the
# sensor is dropping off USB every few seconds, it shows up here.
function Get-SystemEvents {
    param([DateTime]$Since, [int]$Max = 12)

    $results = @()
    try {
        $ev = Get-WinEvent -FilterHashtable @{
            LogName   = 'System'
            StartTime = $Since
        } -MaxEvents 300 -ErrorAction SilentlyContinue

        foreach ($e in @($ev)) {
            $p = [string]$e.ProviderName
            $msg = ([string]$e.Message) -replace '\s+', ' '
            $interesting = $false
            if ($p -match 'Kernel-PnP|USB|Service Control Manager|Kernel-Power|WHEA') { $interesting = $true }
            if ($msg -match 'Kinect|NUI|USB') { $interesting = $true }
            if (-not $interesting) { continue }
            if ($msg.Length -gt 500) { $msg = $msg.Substring(0, 500) + '...' }
            $results += ("{0} [{1}] {2}" -f $e.TimeCreated.ToString('HH:mm:ss'), $p, $msg)
            if ($results.Count -ge $Max) { break }
        }
    }
    catch { }
    return $results
}

function Get-Tail {
    param([string]$Path, [int]$Count = 12)
    try {
        if (-not (Test-Path $Path)) { return @("(no file at $Path)") }
        return @(Get-Content -Path $Path -Tail $Count -ErrorAction SilentlyContinue)
    }
    catch { return @("(could not read $Path)") }
}

# ---------------------------------------------------------------------------
# One-shot snapshot
# ---------------------------------------------------------------------------

function Write-Snapshot {
    Emit 'SNAPSHOT' '===================================================================='
    Emit 'SNAPSHOT' ("kinect-doctor on {0}. Reporting to {1}:{2}. PID={3}" -f $script:Host, $Ip, $Port, $PID)
    Emit 'SNAPSHOT' ("RepoRoot={0}" -f $RepoRoot)

    if ($Ip -eq '255.255.255.255') {
        Emit 'SNAPSHOT' 'WARNING: no wired Ethernet interface found - falling back to 255.255.255.255. The Mac may not receive this. Check the LAN cable.'
    }

    Emit 'SNAPSHOT' ("Kinect device : {0}" -f (Get-DeviceSummary))
    Emit 'SNAPSHOT' ("KinectMonitor : {0}" -f (Get-ServiceStatus 'KinectMonitor'))

    $procs = Get-MoveBeatProcesses
    if ($procs.Count -eq 0) {
        Emit 'SNAPSHOT' 'MoveBeat.exe  : NOT RUNNING'
    }
    else {
        foreach ($p in $procs) {
            $up = 'unknown'
            try { $up = ('{0:F0}s' -f ((Get-Date) - $p.StartTime).TotalSeconds) } catch { }
            Emit 'SNAPSHOT' ("MoveBeat.exe  : PID={0} uptime={1}" -f $p.Id, $up)
        }
        if ($procs.Count -gt 1) {
            Emit 'SNAPSHOT' ("WARNING: {0} copies of MoveBeat.exe are running at once." -f $procs.Count)
        }
    }

    # Kinect Studio gates the live feed for every other client. CLAUDE.md
    # already records this costing a debugging session; check it explicitly.
    $kstudio = @(Get-Process -Name KStudio -ErrorAction SilentlyContinue)
    if ($kstudio.Count -gt 0) {
        Emit 'SNAPSHOT' 'WARNING: Kinect Studio (KStudio.exe) is RUNNING. It can gate or replace the live sensor feed for every other client - including MoveBeat.exe. Close it.'
    }
    $bodyBasics = @(Get-Process -Name BodyBasics-D2D -ErrorAction SilentlyContinue)
    Emit 'SNAPSHOT' ("Body Basics   : {0}" -f $(if ($bodyBasics.Count -gt 0) { 'running' } else { 'not running' }))

    Emit-Block 'SNAPSHOT' 'Power / USB suspend' (Get-PowerSummary)
    Emit-Block 'SNAPSHOT' 'Recent app crashes (Application log, last 2h)' (Get-CrashEvents ((Get-Date).AddHours(-2)))
    Emit-Block 'SNAPSHOT' 'Recent device/service events (System log, last 2h)' (Get-SystemEvents ((Get-Date).AddHours(-2)))
    Emit-Block 'SNAPSHOT' 'movebeat.log (tail)' (Get-Tail $MoveBeatLog 15)
    Emit-Block 'SNAPSHOT' 'sync.log (tail)' (Get-Tail $SyncLog 10)
    Emit 'SNAPSHOT' '=== end of snapshot ==='
}

# ---------------------------------------------------------------------------
# Single-instance guard
# ---------------------------------------------------------------------------
$mutex = New-Object System.Threading.Mutex($false, 'MoveBeatKinectDoctorMutex')
$gotMutex = $false
try { $gotMutex = $mutex.WaitOne(0) }
catch [System.Threading.AbandonedMutexException] { $gotMutex = $true }

if (-not $gotMutex) {
    # Expected and harmless: MoveBeat.exe starts the doctor every time it
    # starts, and in a crash loop that is often. Only one may run.
    Write-Host 'kinect-doctor is already running - exiting.'
    exit 0
}

Write-Snapshot

if ($Once) {
    Emit 'DONE' 'Snapshot complete (-Once). Exiting.'
    exit 0
}

# ---------------------------------------------------------------------------
# Watch loop
#
# Everything here is a TRANSITION detector. A steady state is reported once a
# minute as a heartbeat; a change is reported the instant it is seen. That is
# what turns "it keeps crashing" into a timestamped sequence.
# ---------------------------------------------------------------------------

Emit 'WATCH' ("Watching every {0}s. Restart intervals, sensor drops and crash records will be reported as they happen." -f $IntervalSeconds)

$lastPid        = $null
$lastPidStart   = $null
$lastDevice     = Get-DeviceSummary
$lastService    = Get-ServiceStatus 'KinectMonitor'
$lastEventScan  = (Get-Date).AddSeconds(-10)
$startTimes     = @()          # MoveBeat.exe start times, for interval maths
$exitCount      = 0
$deviceFlaps    = 0
$lastHeartbeat  = [DateTime]::MinValue
$doctorStart    = Get-Date

$procs = Get-MoveBeatProcesses
if ($procs.Count -gt 0) {
    $lastPid = $procs[0].Id
    try { $lastPidStart = $procs[0].StartTime } catch { $lastPidStart = Get-Date }
}

while ($true) {
    try {
        # --- MoveBeat.exe lifetime ---------------------------------------
        $procs = Get-MoveBeatProcesses
        $currentPid = $null
        $currentStart = $null
        if ($procs.Count -gt 0) {
            $currentPid = $procs[0].Id
            try { $currentStart = $procs[0].StartTime } catch { $currentStart = Get-Date }
        }

        if ($null -ne $lastPid -and $null -eq $currentPid) {
            $exitCount++
            $lived = 'unknown'
            if ($null -ne $lastPidStart) {
                $lived = '{0:F1}s' -f ((Get-Date) - $lastPidStart).TotalSeconds
            }
            Emit 'EXIT' ("MoveBeat.exe (PID {0}) is GONE after {1}. Total exits seen: {2}." -f $lastPid, $lived, $exitCount)

            # The event log usually knows why, but takes a moment to be written.
            Start-Sleep -Milliseconds 1500
            $crashes = Get-CrashEvents ((Get-Date).AddMinutes(-2)) 4
            if ($crashes.Count -gt 0) {
                Emit-Block 'EXIT' 'Windows crash records just now' $crashes
            }
            else {
                Emit 'EXIT' 'No Windows crash record found - so it EXITED CLEANLY rather than faulting. Something asked it to close (the auto-updater, a window close, or its own stdin/ENTER path).'
            }
            Emit-Block 'EXIT' 'movebeat.log (tail, its own last words)' (Get-Tail $MoveBeatLog 12)
        }

        if ($null -ne $currentPid -and $currentPid -ne $lastPid) {
            $startTimes += (Get-Date)
            $cut = (Get-Date).AddMinutes(-10)
            $startTimes = @(@($startTimes) | Where-Object { $_ -gt $cut })

            $intervalNote = ''
            if ($startTimes.Count -ge 2) {
                $sorted = @($startTimes | Sort-Object)
                $deltas = @()
                for ($i = 1; $i -lt $sorted.Count; $i++) {
                    $deltas += ($sorted[$i] - $sorted[$i - 1]).TotalSeconds
                }
                $avg = ($deltas | Measure-Object -Average).Average
                $intervalNote = (" {0} starts in the last 10 min, average {1:F1}s apart." -f $startTimes.Count, $avg)
            }
            Emit 'START' ("MoveBeat.exe STARTED, PID {0}.{1}" -f $currentPid, $intervalNote)

            if ($startTimes.Count -ge 4) {
                Emit 'VERDICT' 'The PROCESS is restarting repeatedly - this is not the sensor dropping. Look at the EXIT lines above: a Windows crash record means it is faulting; no record means something is closing it deliberately (check sync.log for the auto-updater).'
            }
        }

        $lastPid = $currentPid
        $lastPidStart = $currentStart

        # --- sensor presence on USB --------------------------------------
        $device = Get-DeviceSummary
        if ($device -ne $lastDevice) {
            $deviceFlaps++
            Emit 'DEVICE' ("Kinect device changed: '{0}' -> '{1}'  (change #{2})" -f $lastDevice, $device, $deviceFlaps)
            if ($deviceFlaps -ge 3) {
                Emit 'VERDICT' 'The SENSOR is dropping off USB and re-enumerating, independently of the app. This is hardware, not code: USB bandwidth, the power adapter, or USB selective suspend. Try a different USB 3.0 controller and confirm the sensor power brick is connected.'
            }
            $lastDevice = $device
        }

        $service = Get-ServiceStatus 'KinectMonitor'
        if ($service -ne $lastService) {
            Emit 'SERVICE' ("KinectMonitor changed: {0} -> {1}" -f $lastService, $service)
            $lastService = $service
        }

        # --- new crash records since the last sweep ----------------------
        $fresh = Get-CrashEvents $lastEventScan 4
        if ($fresh.Count -gt 0) {
            Emit-Block 'CRASH' 'New Windows crash record' $fresh
        }
        $lastEventScan = (Get-Date).AddSeconds(-1)

        # --- heartbeat ----------------------------------------------------
        if (((Get-Date) - $lastHeartbeat).TotalSeconds -ge 60) {
            $lastHeartbeat = Get-Date
            $procTxt = 'not running'
            if ($null -ne $currentPid) {
                $up = 'unknown'
                if ($null -ne $currentStart) { $up = '{0:F0}s' -f ((Get-Date) - $currentStart).TotalSeconds }
                $procTxt = ("PID {0}, up {1}" -f $currentPid, $up)
            }
            Emit 'HB' ("movebeat={0} | device={1} | KinectMonitor={2} | exits={3} | devicechanges={4} | doctor up {5:F0}m" -f `
                $procTxt, $device, $service, $exitCount, $deviceFlaps, ((Get-Date) - $doctorStart).TotalMinutes)
        }
    }
    catch {
        Emit 'ERROR' ("watch loop: " + $_.Exception.Message)
    }

    Start-Sleep -Seconds $IntervalSeconds
}
