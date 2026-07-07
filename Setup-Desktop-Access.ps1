# FocusFlow Desktop Setup
# Optimized for OneDrive - Analog Devices, Inc.

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  FocusFlow - Desktop Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Correct OneDrive paths
$desktopPath = "C:\Users\akumar20\OneDrive - Analog Devices, Inc\Desktop"
$focusFlowSource = Join-Path $PSScriptRoot "FocusFlow.html"
$focusFlowDest = Join-Path $desktopPath "FocusFlow.html"
$shortcutPath = Join-Path $desktopPath "FocusFlow.lnk"

# Verify source file exists
if (-not (Test-Path $focusFlowSource)) {
    Write-Host "ERROR: FocusFlow.html not found in current folder!" -ForegroundColor Red
    Write-Host "Please run this script from the FocusFlow folder." -ForegroundColor Yellow
    exit 1
}

# Verify Desktop folder exists
if (-not (Test-Path $desktopPath)) {
    Write-Host "ERROR: Desktop path not found!" -ForegroundColor Red
    Write-Host "Expected: $desktopPath" -ForegroundColor Yellow
    exit 1
}

Write-Host "Step 1: Copying FocusFlow to Desktop..." -ForegroundColor Cyan
try {
    Copy-Item $focusFlowSource $focusFlowDest -Force
    Write-Host "SUCCESS: Copied to Desktop" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to copy file" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Step 2: Creating desktop shortcut..." -ForegroundColor Cyan
try {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $focusFlowDest
    $Shortcut.Description = "FocusFlow - AI-Powered Productivity Companion"
    $Shortcut.WorkingDirectory = $desktopPath
    $Shortcut.Save()
    Write-Host "SUCCESS: Desktop shortcut created" -ForegroundColor Green
} catch {
    Write-Host "WARNING: Could not create shortcut" -ForegroundColor Yellow
    Write-Host "You can still open FocusFlow.html directly from Desktop" -ForegroundColor White
}

Write-Host ""
Write-Host "Step 3: Opening FocusFlow..." -ForegroundColor Cyan
Start-Process $focusFlowDest
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "FocusFlow Location:" -ForegroundColor Cyan
Write-Host "  $focusFlowDest" -ForegroundColor Yellow
Write-Host ""

Write-Host "Daily Access:" -ForegroundColor Cyan
Write-Host "  1. Double-click 'FocusFlow.lnk' on your desktop" -ForegroundColor White
Write-Host "  2. Or open FocusFlow.html directly" -ForegroundColor White
Write-Host ""

Write-Host "Next Steps in Browser:" -ForegroundColor Cyan
Write-Host "  1. Click 'Allow' when prompted for notifications" -ForegroundColor White
Write-Host "  2. Press Ctrl+D to bookmark the page" -ForegroundColor White
Write-Host "  3. Right-click tab -> 'Pin tab' to keep it always open" -ForegroundColor White
Write-Host "  4. Try the AI Goal Parser button!" -ForegroundColor White
Write-Host ""

Write-Host "Optional - Hourly Reminders:" -ForegroundColor Yellow
Write-Host "  Run: .\Setup-FocusFlow-Reminders.ps1" -ForegroundColor White
Write-Host ""

Write-Host "Happy focusing!" -ForegroundColor Magenta
Write-Host ""
