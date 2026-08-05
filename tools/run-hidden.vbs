' MoveBeat auto-updater launcher shim.
'
' "powershell -WindowStyle Hidden" still allocates a console before hiding
' it, so it flashes on screen. The Task Scheduler "Hidden" checkbox only
' hides the task from the MMC list - it has no effect on windows. Applying
' SW_HIDE at CreateProcess time (the 0 below, via WScript.Shell.Run) is the
' reliable no-flash mechanism.
'
' -ExecutionPolicy Bypass is required (policy is effectively Restricted).
' -NonInteractive prevents any prompt from hanging the process forever.

CreateObject("WScript.Shell").Run _
  "powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File ""C:\dev\MoveBeat\tools\sync-loop.ps1""", 0, False
