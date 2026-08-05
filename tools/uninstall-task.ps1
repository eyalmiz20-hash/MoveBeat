# Unregisters the MoveBeat auto-updater scheduled task and kills any
# running poller. Needed for debugging - does not touch MoveBeat.exe itself.

$ErrorActionPreference = 'Continue'

$TaskName = 'MoveBeatAutoUpdate'

$existing = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($existing) {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
    Write-Host "Unregistered scheduled task '$TaskName'."
}
else {
    Write-Host "No scheduled task named '$TaskName' found."
}

# Kill any running poller (a powershell.exe process running sync-loop.ps1,
# whether started by the task or launched manually for testing).
$killed = 0
Get-CimInstance Win32_Process -Filter "Name = 'powershell.exe'" -ErrorAction SilentlyContinue | ForEach-Object {
    if ($_.CommandLine -and $_.CommandLine -like '*sync-loop.ps1*') {
        Write-Host ("Stopping poller process PID {0}" -f $_.ProcessId)
        Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
        $killed++
    }
}
if ($killed -eq 0) {
    Write-Host 'No running poller process found.'
}

Write-Host 'Done. MoveBeat.exe itself, if running, was left alone - stop it manually if desired.'
