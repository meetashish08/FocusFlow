@echo off
echo Starting FocusFlow...
start "" "%~dp0FocusFlow.html"
echo.
echo FocusFlow is now open in your browser!
echo.
echo Tips:
echo - Allow notifications when prompted
echo - Run Setup-FocusFlow-Reminders.ps1 for hourly reminders
echo.
timeout /t 3 >nul
