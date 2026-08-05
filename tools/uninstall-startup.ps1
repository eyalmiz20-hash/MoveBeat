# Removes the Startup-folder auto-updater installed by install-startup.ps1,
# and stops any running poller. Does not touch MoveBeat.exe itself.

$ErrorActionPreference = 'Continue'

$ShortcutPath = Join-Path ([Environment]::GetFolderPath('Startup')) 'MoveBeatAutoUpdate.lnk'

if (Test-Path $ShortcutPath) {
    Remove-Item $ShortcutPath -Force
    Write-Host "Removed $ShortcutPath"
}
else {
    Write-Host 'No Startup shortcut found.'
}

# Stop any running poller. Match on the script name in the command line, and
# never match this very process (a shell that happens to mention the script
# name in its own command line would otherwise kill itself).
$pattern = '*' + 'sync-loop' + '.ps1*'
$killed = 0
Get-CimInstance Win32_Process -Filter "Name = 'powershell.exe'" -ErrorAction SilentlyContinue | ForEach-Object {
    if ($_.ProcessId -ne $PID -and $_.CommandLine -and $_.CommandLine -like $pattern) {
        Write-Host ("Stopping poller process PID {0}" -f $_.ProcessId)
        Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
        $killed++
    }
}
if ($killed -eq 0) { Write-Host 'No running poller process found.' }

Write-Host 'Done. MoveBeat.exe itself, if running, was left alone.'
