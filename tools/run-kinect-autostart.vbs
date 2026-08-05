' Launches kinect-autostart.ps1 with no console flash.
'
' Same reasoning as run-hidden.vbs: "powershell -WindowStyle Hidden" still
' allocates a console before hiding it, so it flashes on screen. Applying
' SW_HIDE at CreateProcess time (the 0 below) is the reliable mechanism.
'
' The apps this script launches still get their own visible windows -- only
' the launcher itself is hidden.

CreateObject("WScript.Shell").Run _
  "powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File ""C:\dev\MoveBeat\tools\kinect-autostart.ps1""", 0, False
