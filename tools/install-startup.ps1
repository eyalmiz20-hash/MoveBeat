# Installs the MoveBeat auto-updater via the user's Startup folder.
#
# This is the DEFAULT installer. Use it instead of install-task.ps1, which
# needs administrator rights this account does not have (Register-ScheduledTask
# and schtasks.exe both fail with Access Denied here).
#
# The Startup folder is arguably the better mechanism for this job anyway:
#   - No admin required.
#   - Runs in the interactive logon session by definition, which the Kinect
#     needs (session 0 is kernel-isolated from the desktop, has no visible
#     window, and Kinect v2 arbitrates the sensor per-session).
#   - Not subject to Task Scheduler's battery policy, which on a laptop
#     otherwise refuses to start on battery and kills the task when unplugged.
#   - The 30s settle delay that a task trigger would provide is already built
#     into sync-loop.ps1 itself.
#
# Trade-off vs Task Scheduler: no automatic restart if the poller process
# dies. sync-loop.ps1 wraps each cycle in try/catch so it should not, but if
# it ever does, log off and back on (or re-run run-hidden.vbs by hand).

$ErrorActionPreference = 'Stop'

$VbsPath      = Join-Path $PSScriptRoot 'run-hidden.vbs'
$StartupDir   = [Environment]::GetFolderPath('Startup')
$ShortcutPath = Join-Path $StartupDir 'MoveBeatAutoUpdate.lnk'

if (-not (Test-Path $VbsPath)) {
    Write-Error "Cannot find $VbsPath"
    exit 1
}

$shell = New-Object -ComObject WScript.Shell
$sc = $shell.CreateShortcut($ShortcutPath)
$sc.TargetPath       = Join-Path $env:WINDIR 'System32\wscript.exe'
$sc.Arguments        = '"' + $VbsPath + '"'
$sc.WorkingDirectory = Split-Path -Parent $PSScriptRoot
$sc.Description      = 'MoveBeat auto-sync: polls GitHub origin/main every 30s, rebuilds and relaunches on change.'
$sc.WindowStyle      = 7   # minimized; the VBS shim applies SW_HIDE to the real work anyway
$sc.Save()

if (-not (Test-Path $ShortcutPath)) {
    Write-Host 'FAILED: shortcut was not created.' -ForegroundColor Red
    exit 1
}

Write-Host "Installed: $ShortcutPath"
Write-Host 'The auto-updater will start automatically at every logon.'
Write-Host ''
Write-Host 'To start it right now without logging out:'
Write-Host "  wscript.exe `"$VbsPath`""
Write-Host ''
Write-Host 'To watch it work:'
Write-Host '  Get-Content C:\dev\MoveBeat\tools\logs\sync.log -Tail 20 -Wait'
Write-Host ''
Write-Host 'To remove it:'
Write-Host '  .\tools\uninstall-startup.ps1'
