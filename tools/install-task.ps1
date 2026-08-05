# One-time registration of the MoveBeat auto-updater as a scheduled task.
# Run this once, interactively, after confirming sync-loop.ps1 behaves
# correctly in a visible console (see tools/sync-loop.ps1 and the plan's
# verification section). Not admin-required.

$ErrorActionPreference = 'Stop'

$TaskName = 'MoveBeatAutoUpdate'
$VbsPath  = 'C:\dev\MoveBeat\tools\run-hidden.vbs'

if (-not (Test-Path $VbsPath)) {
    Write-Error "Cannot find $VbsPath - this script expects the repo at C:\dev\MoveBeat."
    exit 1
}

$existing = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "Task '$TaskName' already exists - unregistering the old copy first."
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

$action = New-ScheduledTaskAction -Execute 'wscript.exe' -Argument ('"' + $VbsPath + '"')

# Trigger at logon, with a 30s delay so KinectMonitor / USB enumeration /
# the network have settled before the first git check.
$trigger = New-ScheduledTaskTrigger -AtLogOn
$trigger.Delay = 'PT30S'

$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -ExecutionTimeLimit ([TimeSpan]::Zero) `
    -RestartCount 999 `
    -RestartInterval (New-TimeSpan -Minutes 1) `
    -MultipleInstances IgnoreNew

# LogonType Interactive + RunLevel Limited: "run whether user is logged on
# or not" would put this in session 0, which is kernel-isolated from the
# desktop (no visible console) and where Kinect v2's per-session sensor
# arbitration should be assumed non-functional. Session 0 is off the table
# for both reasons - this task only ever runs in the interactive session.
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited

Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal `
    -Description 'MoveBeat auto-sync: polls GitHub origin/main every ~30s; on change, kills MoveBeat.exe, mirrors the repo, rebuilds and relaunches.' `
    | Out-Null

Write-Host "Registered scheduled task '$TaskName'."
Write-Host 'It will start automatically at next logon (after a 30s delay).'
Write-Host 'Accepted trade-off: it runs only while this user is logged on, and stops at logoff.'
Write-Host ''
Write-Host 'To start it right now instead of waiting for next logon:'
Write-Host "  Start-ScheduledTask -TaskName '$TaskName'"
Write-Host ''
Write-Host 'To check on it:'
Write-Host "  Get-ScheduledTask -TaskName '$TaskName' | Get-ScheduledTaskInfo"
Write-Host '  Get-Content C:\dev\MoveBeat\tools\logs\sync.log -Tail 20 -Wait'
