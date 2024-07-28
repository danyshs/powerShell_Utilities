@echo off
set "filePath=%~1"
set "fileDir=%~dp1"
set "fileName=%~nx1"
start "" "C:\tools\WezTerm\wezterm-gui.exe" start -- "C:\Program Files\PowerShell\7\pwsh.exe" -Command "cd '%fileDir%'; nvim '%fileName%'"
exit