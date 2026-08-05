# Removes the Kinect app auto-start installed by install-kinect-autostart.ps1.
# Does not close any apps that are currently running.

$ErrorActionPreference = 'Continue'

$ShortcutPath = Join-Path ([Environment]::GetFolderPath('Startup')) 'MoveBeatKinectApps.lnk'

if (Test-Path $ShortcutPath) {
    Remove-Item $ShortcutPath -Force
    Write-Host "Removed $ShortcutPath"
}
else {
    Write-Host 'No Kinect auto-start shortcut found.'
}

Write-Host 'Any apps already running were left alone - close them manually if desired.'
