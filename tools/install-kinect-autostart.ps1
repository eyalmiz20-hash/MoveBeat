# Installs the Kinect app auto-start via the user's Startup folder.
#
# Launches MoveBeat.exe, Body Basics and Kinect Studio at every logon, once
# the sensor reports ready. Edit the $Apps list in kinect-autostart.ps1 to
# change what starts.
#
# No admin required (Register-ScheduledTask fails with Access Denied on this
# machine). Companion to install-startup.ps1, which installs the git
# auto-updater; the two are independent and can be used separately.

$ErrorActionPreference = 'Stop'

$VbsPath      = Join-Path $PSScriptRoot 'run-kinect-autostart.vbs'
$StartupDir   = [Environment]::GetFolderPath('Startup')
$ShortcutPath = Join-Path $StartupDir 'MoveBeatKinectApps.lnk'

if (-not (Test-Path $VbsPath)) {
    Write-Error "Cannot find $VbsPath"
    exit 1
}

$shell = New-Object -ComObject WScript.Shell
$sc = $shell.CreateShortcut($ShortcutPath)
$sc.TargetPath       = Join-Path $env:WINDIR 'System32\wscript.exe'
$sc.Arguments        = '"' + $VbsPath + '"'
$sc.WorkingDirectory = Split-Path -Parent $PSScriptRoot
$sc.Description      = 'Launches the Kinect applications at logon once the sensor is ready.'
$sc.WindowStyle      = 7
$sc.Save()

if (-not (Test-Path $ShortcutPath)) {
    Write-Host 'FAILED: shortcut was not created.' -ForegroundColor Red
    exit 1
}

Write-Host "Installed: $ShortcutPath"
Write-Host 'At every logon this will wait for the Kinect, then launch:'
Write-Host '  - MoveBeat.exe      (Kinect -> OSC sender)'
Write-Host '  - Body Basics       (live skeleton view)'
Write-Host '  - Kinect Studio     (depth/IR/body recording tool)'
Write-Host ''
Write-Host 'To run it right now without logging out:'
Write-Host "  wscript.exe `"$VbsPath`""
Write-Host ''
Write-Host 'To see what it did:'
Write-Host '  Get-Content C:\dev\MoveBeat\tools\logs\kinect-autostart.log -Tail 20'
Write-Host ''
Write-Host 'To change which apps start: edit the $Apps list in tools\kinect-autostart.ps1'
Write-Host 'To remove: .\tools\uninstall-kinect-autostart.ps1'
