# FocusFlow Hourly Reminder Setup
# This script sets up Windows notifications to remind you every hour

param(
    [switch]$Remove,
    [switch]$AddStartup
)

$TaskName = "FocusFlow Hourly Reminder"
$FocusFlowPath = Join-Path $PSScriptRoot "FocusFlow.html"
$StartupFolder = [Environment]::GetFolderPath('Startup')

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  FocusFlow - Hourly Reminder Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Remove existing task if -Remove flag is used
if ($Remove) {
    Write-Host "Removing FocusFlow reminders..." -ForegroundColor Yellow

    # Remove scheduled task
    $existingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if ($existingTask) {
        Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
        Write-Host "Scheduled task removed successfully!" -ForegroundColor Green
    } else {
        Write-Host "No scheduled task found." -ForegroundColor Yellow
    }

    # Remove startup shortcut
    $shortcutPath = Join-Path $StartupFolder "FocusFlow.lnk"
    if (Test-Path $shortcutPath) {
        Remove-Item $shortcutPath -Force
        Write-Host "Startup shortcut removed!" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "FocusFlow reminders have been removed." -ForegroundColor Green
    Write-Host ""
    exit
}

# Check if FocusFlow.html exists
if (-not (Test-Path $FocusFlowPath)) {
    Write-Host "ERROR: FocusFlow.html not found!" -ForegroundColor Red
    Write-Host "Make sure this script is in the same folder as FocusFlow.html" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host "Setting up hourly reminders..." -ForegroundColor Cyan
Write-Host ""

# Remove existing task if it exists
$existingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Host "Removing existing task..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

# PowerShell command to show toast notification
$toastScript = @'
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

$quotes = @(
    "Your only limit is you.",
    "Dream big. Start small. Act now.",
    "Progress, not perfection.",
    "Small steps every day lead to big changes.",
    "You are capable of amazing things.",
    "The best time to start was yesterday. The next best time is now.",
    "Don't watch the clock; do what it does. Keep going.",
    "Success is the sum of small efforts repeated daily.",
    "What you do today can improve all your tomorrows.",
    "Your future self will thank you.",
    "Make each day your masterpiece.",
    "Start where you are. Use what you have. Do what you can.",
    "Don't count the days, make the days count.",
    "The secret of getting ahead is getting started.",
    "It always seems impossible until it's done.",
    "Do something today that your future self will thank you for.",
    "Push yourself, because no one else is going to do it for you.",
    "The future depends on what you do today."
)

$quote = $quotes | Get-Random

$template = @"
<toast>
    <visual>
        <binding template="ToastGeneric">
            <text>⏰ FocusFlow Reminder</text>
            <text>Check your tasks and goals!</text>
            <text>$quote</text>
        </binding>
    </visual>
    <audio src="ms-winsoundevent:Notification.Default" />
</toast>
"@

$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml($template)

$toast = New-Object Windows.UI.Notifications.ToastNotification $xml
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("FocusFlow").Show($toast)
'@

# Save the toast script to a file
$toastScriptPath = Join-Path $PSScriptRoot "Show-FocusFlow-Reminder.ps1"
$toastScript | Out-File -FilePath $toastScriptPath -Encoding UTF8 -Force

# Create the scheduled task action
$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$toastScriptPath`""

# Create trigger for every hour during waking hours (8 AM - 10 PM)
$triggers = @()
for ($hour = 8; $hour -le 22; $hour++) {
    $triggers += New-ScheduledTaskTrigger -Daily -At "$($hour):00"
}

# Task settings
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 1)

# Principal (run as current user)
$principal = New-ScheduledTaskPrincipal `
    -UserId $env:USERNAME `
    -LogonType S4U `
    -RunLevel Limited

# Register the task
try {
    Register-ScheduledTask `
        -TaskName $TaskName `
        -Action $action `
        -Trigger $triggers `
        -Settings $settings `
        -Principal $principal `
        -Description "Hourly reminder to check FocusFlow tasks and goals" `
        -Force | Out-Null

    Write-Host "Hourly reminder task created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Reminders will appear:" -ForegroundColor Cyan
    Write-Host "- Every hour from 8 AM to 10 PM" -ForegroundColor White
    Write-Host "- As Windows notifications" -ForegroundColor White
    Write-Host "- With motivational quotes" -ForegroundColor White
    Write-Host ""
} catch {
    Write-Host "ERROR: Failed to create scheduled task" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    exit 1
}

# Add startup shortcut if requested
if ($AddStartup) {
    Write-Host "Adding FocusFlow to startup..." -ForegroundColor Cyan

    $WshShell = New-Object -ComObject WScript.Shell
    $shortcutPath = Join-Path $StartupFolder "FocusFlow.lnk"
    $shortcut = $WshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $FocusFlowPath
    $shortcut.Description = "FocusFlow - Daily Productivity Companion"
    $shortcut.Save()

    Write-Host "Startup shortcut created!" -ForegroundColor Green
    Write-Host "FocusFlow will open automatically when you log in." -ForegroundColor White
    Write-Host ""
}

# Test notification
Write-Host "Testing notification..." -ForegroundColor Cyan
Write-Host ""

try {
    & $toastScriptPath
    Start-Sleep -Seconds 2
    Write-Host "Test notification sent! Check your notification center." -ForegroundColor Green
} catch {
    Write-Host "Note: You may need to allow notifications for PowerShell in Windows Settings." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Open FocusFlow.html in your browser" -ForegroundColor White
Write-Host "2. Allow browser notifications when prompted" -ForegroundColor White
Write-Host "3. You'll receive hourly reminders automatically" -ForegroundColor White
Write-Host ""
Write-Host "Commands:" -ForegroundColor Cyan
Write-Host "- View task: " -NoNewline -ForegroundColor White
Write-Host 'Get-ScheduledTask -TaskName "FocusFlow Hourly Reminder"' -ForegroundColor Yellow
Write-Host "- Test reminder: " -NoNewline -ForegroundColor White
Write-Host ".\Show-FocusFlow-Reminder.ps1" -ForegroundColor Yellow
Write-Host "- Remove reminders: " -NoNewline -ForegroundColor White
Write-Host ".\Setup-FocusFlow-Reminders.ps1 -Remove" -ForegroundColor Yellow
Write-Host ""
Write-Host "Happy focusing! 🚀" -ForegroundColor Magenta
Write-Host ""
