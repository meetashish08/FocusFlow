# FocusFlow Deployment Guide

## Table of Contents
- [System Requirements](#system-requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Windows Scheduled Task Setup](#windows-scheduled-task-setup)
- [Browser Configuration](#browser-configuration)
- [Backup & Restore](#backup--restore)
- [Troubleshooting](#troubleshooting)
- [Performance Optimization](#performance-optimization)
- [Security Considerations](#security-considerations)
- [Browser Compatibility](#browser-compatibility)
- [Maintenance](#maintenance)
- [Advanced Deployment Scenarios](#advanced-deployment-scenarios)

---

## System Requirements

### Minimum Requirements

**Hardware:**
- CPU: Any modern processor (2010+)
- RAM: 2 GB
- Storage: 1 MB free disk space
- Display: 1024x768 minimum resolution

**Software:**
- Operating System: Windows 10+, macOS 10.12+, Linux (any modern distro)
- Web Browser: Chrome 90+, Firefox 88+, Edge 90+, Safari 14+
- No additional software required

**Network:**
- No internet connection required (app runs offline)
- Internet needed only for initial download

---

### Recommended Specifications

**Hardware:**
- CPU: Intel Core i3 or equivalent
- RAM: 4 GB
- Display: 1920x1080 (full HD)

**Software:**
- Latest version of Chrome or Edge
- Windows 10/11 (for scheduled task integration)

---

## Installation

### Method 1: Direct File Access (Recommended)

**Step 1:** Copy the File
```
Copy FocusFlow.html to a permanent location:

Recommended locations:
  Windows: C:\Users\[YourName]\Documents\FocusFlow\
  macOS:   ~/Documents/FocusFlow/
  Linux:   ~/Documents/FocusFlow/
```

**Step 2:** Create Desktop Shortcut (Optional)

**Windows:**
1. Right-click `FocusFlow.html`
2. Select "Send to" → "Desktop (create shortcut)"
3. Rename shortcut to "FocusFlow"

**macOS:**
1. Drag `FocusFlow.html` to Dock while holding ⌘+⌥
2. Release to create alias

**Linux:**
```bash
ln -s ~/Documents/FocusFlow/FocusFlow.html ~/Desktop/FocusFlow.html
```

**Step 3:** Pin to Browser (Optional)

1. Open FocusFlow.html in browser
2. Click browser menu (⋮)
3. Select "Install app" or "Create shortcut"
4. Check "Open in window" for app-like experience

---

### Method 2: Web Server Hosting

For team deployment or always-available access:

**Option A: Local Server (Python)**

```bash
# Navigate to FocusFlow directory
cd C:\Users\YourName\Documents\FocusFlow

# Start simple HTTP server
python -m http.server 8080

# Access at: http://localhost:8080/FocusFlow.html
```

**Option B: GitHub Pages (Free Hosting)**

1. Create GitHub repository
2. Upload `FocusFlow.html`
3. Enable GitHub Pages in repository settings
4. Access at: `https://[username].github.io/[repo]/FocusFlow.html`

**Option C: Intranet Deployment**

```
Copy FocusFlow.html to company intranet server:
  \\intranet\apps\productivity\FocusFlow.html

Users access via:
  file://intranet/apps/productivity/FocusFlow.html
```

---

### Method 3: Browser Extension (Packaged Web App)

For Chrome/Edge:

**manifest.json:**
```json
{
  "manifest_version": 3,
  "name": "FocusFlow",
  "version": "1.0",
  "description": "Daily productivity companion",
  "action": {
    "default_popup": "FocusFlow.html"
  },
  "permissions": ["storage", "notifications"]
}
```

Package as unpacked extension for personal use.

---

## Configuration

### Default Settings

FocusFlow works out-of-the-box with these defaults:

```javascript
{
  focusDuration: 25,        // minutes
  breakDuration: 5,         // minutes
  notificationsEnabled: false  // user must grant permission
}
```

---

### Customizing Default Settings

To change defaults before first use:

**Step 1:** Open `FocusFlow.html` in text editor

**Step 2:** Find settings initialization (around line 839):
```javascript
settings: {
    focusDuration: 25,      // Change to 30, 45, etc.
    breakDuration: 5,       // Change to 10, 15, etc.
    notificationsEnabled: false
}
```

**Step 3:** Modify values

**Step 4:** Save file

**Note:** Changes only affect new users. Existing users retain their localStorage settings.

---

### Customizing Appearance

**Color Scheme:**

Find `:root` CSS variables (lines 14-25):
```css
:root {
    --bg-primary: #1a1a2e;      /* Main background */
    --bg-secondary: #16213e;    /* Panel backgrounds */
    --accent: #e94560;          /* Brand color */
    /* ... modify as needed ... */
}
```

**Company Branding:**

Change header text (line 560):
```html
<h1>🚀 FocusFlow</h1>
<!-- Change to: -->
<h1>🚀 [Your Company] Productivity</h1>
```

**Quotes:**

Replace quotes array (lines 777-828) with custom motivational messages.

---

## Windows Scheduled Task Setup

Enable hourly desktop reminders even when browser is closed.

### Prerequisites
- Windows 10 or later
- PowerShell 5.1+
- Administrator privileges (for scheduled task creation)

---

### Automated Setup Script

**Step 1:** Create `FocusFlowReminder.ps1`

```powershell
# FocusFlow Reminder Script
# Displays notification to check FocusFlow

Add-Type -AssemblyName System.Windows.Forms

# Array of motivational quotes (sample)
$quotes = @(
    "Time to check your tasks!",
    "Stay focused on your goals!",
    "Small steps lead to big changes!",
    "Keep up the great work!"
)

$randomQuote = $quotes | Get-Random

# Create notification
$notification = New-Object System.Windows.Forms.NotifyIcon
$notification.Icon = [System.Drawing.SystemIcons]::Information
$notification.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
$notification.BalloonTipTitle = "⏰ FocusFlow Reminder"
$notification.BalloonTipText = $randomQuote
$notification.Visible = $true
$notification.ShowBalloonTip(5000)

# Keep script alive briefly to show notification
Start-Sleep -Seconds 6

# Cleanup
$notification.Dispose()
```

**Save to:** `C:\Users\[YourName]\Documents\FocusFlow\FocusFlowReminder.ps1`

---

**Step 2:** Create Scheduled Task

Open PowerShell **as Administrator** and run:

```powershell
# Variables
$taskName = "FocusFlowHourlyReminder"
$scriptPath = "C:\Users\$env:USERNAME\Documents\FocusFlow\FocusFlowReminder.ps1"
$description = "Hourly reminder to check FocusFlow tasks and goals"

# Create action (run PowerShell script)
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-WindowStyle Hidden -File `"$scriptPath`""

# Create trigger (hourly during work hours: 8 AM - 6 PM)
$triggers = @()
for ($hour = 8; $hour -le 18; $hour++) {
    $triggers += New-ScheduledTaskTrigger -Daily -At "$($hour):00"
}

# Create settings
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable

# Create principal (run as current user)
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" `
    -LogonType Interactive

# Register task
Register-ScheduledTask -TaskName $taskName `
    -Action $action `
    -Trigger $triggers `
    -Settings $settings `
    -Principal $principal `
    -Description $description `
    -Force

Write-Host "✅ Scheduled task created successfully!" -ForegroundColor Green
Write-Host "Task will run hourly from 8 AM to 6 PM daily." -ForegroundColor Cyan
```

---

**Step 3:** Verify Installation

```powershell
# List FocusFlow scheduled tasks
Get-ScheduledTask | Where-Object {$_.TaskName -like "*FocusFlow*"}

# Test run the reminder immediately
Start-ScheduledTask -TaskName "FocusFlowHourlyReminder"
```

You should see a notification balloon appear.

---

### Manual Scheduled Task Setup

If you prefer GUI setup:

1. **Open Task Scheduler**
   - Press `Win + R`
   - Type `taskschd.msc`
   - Press Enter

2. **Create New Task**
   - Click "Create Task" (not "Create Basic Task")
   - Name: `FocusFlowHourlyReminder`
   - Description: `Hourly reminder to check FocusFlow`
   - Check: ☑ Run whether user is logged on or not
   - Check: ☑ Do not store password

3. **Triggers Tab**
   - Click "New..."
   - Settings:
     - Begin: On a schedule
     - Daily, recur every 1 day
     - Repeat task every: 1 hour
     - For a duration of: Indefinitely
     - Start time: 8:00 AM
     - Stop task if it runs longer than: 30 minutes
   - Click OK

4. **Actions Tab**
   - Click "New..."
   - Action: Start a program
   - Program/script: `PowerShell.exe`
   - Arguments: `-WindowStyle Hidden -File "C:\Users\[YourName]\Documents\FocusFlow\FocusFlowReminder.ps1"`
   - Click OK

5. **Conditions Tab**
   - Uncheck: ☐ Start task only if computer is on AC power
   - Check: ☑ Wake the computer to run this task (optional)

6. **Settings Tab**
   - Check: ☑ Allow task to be run on demand
   - Check: ☑ Run task as soon as possible after scheduled start is missed
   - If the running task does not end when requested: Stop the existing instance

7. **Click OK** to save

---

### Customizing Reminder Schedule

**Business Hours Only (9 AM - 5 PM):**
```powershell
for ($hour = 9; $hour -le 17; $hour++) {
    $triggers += New-ScheduledTaskTrigger -Daily -At "$($hour):00"
}
```

**Every 2 Hours:**
```powershell
for ($hour = 8; $hour -le 18; $hour += 2) {
    $triggers += New-ScheduledTaskTrigger -Daily -At "$($hour):00"
}
```

**Weekdays Only:**
Add to trigger creation:
```powershell
-DaysOfWeek Monday,Tuesday,Wednesday,Thursday,Friday
```

---

### Disabling Reminders

**Temporary:**
```powershell
Disable-ScheduledTask -TaskName "FocusFlowHourlyReminder"
```

**Permanent:**
```powershell
Unregister-ScheduledTask -TaskName "FocusFlowHourlyReminder" -Confirm:$false
```

---

## Browser Configuration

### Enable Notifications

**Chrome/Edge:**
1. Open FocusFlow
2. Click 🔔 icon in address bar when prompted
3. Select "Allow"

**Firefox:**
1. Open FocusFlow
2. Click gear icon in address bar when prompted
3. Select "Allow Notifications"

**Safari:**
1. Safari → Preferences → Websites → Notifications
2. Find FocusFlow.html
3. Set to "Allow"

---

### Install as Progressive Web App (PWA)

FocusFlow can run as a standalone app:

**Chrome/Edge:**
1. Open FocusFlow
2. Click menu (⋮) → "Install FocusFlow"
3. Confirm installation
4. App appears in Start Menu / Applications

**Benefits:**
- Separate window (no browser UI)
- App icon in taskbar
- Faster access

---

### Set as New Tab Page (Chrome Extension)

**manifest.json:**
```json
{
  "manifest_version": 3,
  "name": "FocusFlow New Tab",
  "version": "1.0",
  "chrome_url_overrides": {
    "newtab": "FocusFlow.html"
  }
}
```

Load as unpacked extension. Every new tab shows FocusFlow!

---

### Configure Browser Permissions

**Recommended Permissions:**
- ✅ Notifications
- ✅ localStorage
- ✅ Web Audio (for sounds)

**Not Required:**
- ❌ Camera
- ❌ Microphone
- ❌ Location

---

## Backup & Restore

### Manual Backup

**Method 1: Export Feature (Built-in)**

1. Open FocusFlow
2. Click "💾 Export Data" in Quick Actions
3. File downloads: `focusflow-backup-YYYY-MM-DD.json`
4. Save to cloud storage (Google Drive, Dropbox, OneDrive)

**Recommended Schedule:** Weekly or after major XP milestones

---

**Method 2: Browser Developer Tools**

1. Open FocusFlow
2. Press `F12` (Developer Tools)
3. Go to "Application" tab (Chrome) or "Storage" tab (Firefox)
4. Expand "Local Storage"
5. Click on `file://` or your domain
6. Find `focusflow_data` key
7. Copy value (JSON string)
8. Paste into text file, save as `.json`

---

### Automated Backup Script

**Windows PowerShell:**

```powershell
# FocusFlow Backup Script
# Extracts localStorage from Chrome and saves to file

$backupDir = "C:\Users\$env:USERNAME\Documents\FocusFlow\Backups"
$dateStamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$backupFile = "$backupDir\focusflow-auto-backup-$dateStamp.json"

# Create backup directory if needed
if (!(Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
}

# Chrome localStorage path (adjust if needed)
$chromePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Local Storage\leveldb"

# Note: Direct extraction from Chrome's LevelDB is complex
# Recommended: Use Export feature instead

Write-Host "Use the built-in Export feature for reliable backups." -ForegroundColor Yellow
Write-Host "Saved to: $backupFile" -ForegroundColor Cyan
```

**Better Approach:** Schedule Export reminder as task:
```powershell
# Weekly backup reminder
$action = New-ScheduledTaskAction -Execute "msg.exe" `
    -Argument "$env:USERNAME /TIME:0 'Time to backup FocusFlow! Use Export Data feature.'"
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At "6:00PM"
Register-ScheduledTask -TaskName "FocusFlowBackupReminder" `
    -Action $action -Trigger $trigger
```

---

### Restore from Backup

**Step 1:** Open FocusFlow

**Step 2:** Click "📥 Import Data" in Quick Actions

**Step 3:** Select backup JSON file

**Step 4:** Confirm replacement

**Step 5:** Data restored! (Page refreshes automatically)

---

### localStorage Direct Access (Advanced)

**View Current Data:**

```javascript
// Paste in browser console (F12)
const data = localStorage.getItem('focusflow_data');
console.log(JSON.parse(data));
```

**Manual Restore:**

```javascript
// Paste in browser console
const backupData = { /* paste backup JSON here */ };
localStorage.setItem('focusflow_data', JSON.stringify(backupData));
location.reload(); // Refresh page
```

---

### Backup Strategy Recommendations

**Personal Use:**
- Export monthly
- Store in cloud (Google Drive, OneDrive)
- Keep last 3 backups

**Critical Use (Long Streaks):**
- Export weekly
- Store in 2 locations (cloud + local external drive)
- Keep all backups

**Team Deployment:**
- Educate users on export feature
- Provide backup script in onboarding docs
- Consider centralized backup if using web server

---

## Troubleshooting

### Issue: Data Not Persisting

**Symptoms:** Tasks/goals disappear after closing browser.

**Causes:**
1. Private/Incognito mode (localStorage disabled)
2. Browser set to clear data on exit
3. localStorage quota exceeded
4. Browser extension blocking localStorage

**Solutions:**

**Check Browser Mode:**
- Exit private/incognito mode
- Use normal browsing window

**Check Browser Settings:**

Chrome:
1. Settings → Privacy and security → Cookies and other site data
2. Ensure "Clear cookies and site data when you close all windows" is OFF

Firefox:
1. Settings → Privacy & Security → Cookies and Site Data
2. Uncheck "Delete cookies and site data when Firefox is closed"

**Check localStorage:**
```javascript
// Browser console
try {
    localStorage.setItem('test', 'test');
    localStorage.removeItem('test');
    console.log('✅ localStorage working');
} catch (e) {
    console.error('❌ localStorage blocked:', e);
}
```

**Workaround:**
- Export data before closing
- Import on next session
- Consider cloud sync solution

---

### Issue: Notifications Not Showing

**Symptoms:** No hourly reminders or timer alerts.

**Diagnosis:**

**Check Permission:**
```javascript
// Browser console
console.log('Notification permission:', Notification.permission);
// Should return: "granted"
```

**Solutions:**

**Grant Permission:**
1. Click 🔔 icon in browser address bar
2. Select "Allow"
3. Reload page

**Reset Permission:**

Chrome:
1. Settings → Privacy and security → Site Settings
2. Notifications → find FocusFlow
3. Change to "Allow"

**Check Do Not Disturb (Windows):**
1. Settings → System → Focus Assist
2. Set to "Off" or configure priority list

**Verify in Code:**
1. Open FocusFlow
2. Click "🔔 Test Reminder"
3. Should see notification

---

### Issue: Timer Inaccurate

**Symptoms:** 25-minute timer takes 27+ minutes.

**Cause:** Browser throttles background tabs.

**Solutions:**

**Keep Tab Active:**
- Don't switch tabs during focus session
- Use separate window for FocusFlow

**Use Audio Cue:**
- Enable system volume
- Sound plays when timer completes

**Use PWA Install:**
- Installed apps get better resource priority
- Less likely to be throttled

**Alternative:** Use physical timer as backup verification.

---

### Issue: Confetti Animation Laggy

**Symptoms:** Choppy animation on task completion.

**Causes:**
1. Low-end hardware
2. Too many browser tabs open
3. High CPU usage from other apps

**Solutions:**

**Reduce Particle Count:**

Edit line 1477:
```javascript
for (let i = 0; i < 50; i++) {  // Reduce to 25
```

**Disable Confetti:**

Comment out celebration calls:
```javascript
function celebrate() {
    // launchConfetti();  // Disabled
    showRandomQuote();
}
```

**Close Other Tabs:**
- Free up system resources

---

### Issue: Import Fails

**Symptoms:** "Invalid backup file!" error.

**Causes:**
1. Corrupted JSON file
2. Wrong file format (not JSON)
3. Incompatible schema version

**Solutions:**

**Validate JSON:**
Use online JSON validator:
- https://jsonlint.com/
- Paste file contents
- Check for syntax errors

**Check File Structure:**
```json
{
  "tasks": [...],
  "goals": [...],
  "xp": 0,
  // Must have correct structure
}
```

**Try Manual Import:**
```javascript
// Console method
const data = { /* paste validated JSON */ };
localStorage.setItem('focusflow_data', JSON.stringify(data));
location.reload();
```

---

### Issue: Streak Reset Unexpectedly

**Symptoms:** Streak shows 0 despite daily use.

**Causes:**
1. Didn't complete any tasks yesterday
2. Skipped a day
3. Opened before midnight, again after midnight (same day)
4. Browser cleared localStorage

**Diagnosis:**

Check last open date:
```javascript
// Console
const data = JSON.parse(localStorage.getItem('focusflow_data'));
console.log('Last open:', data.lastOpenDate);
console.log('Completed yesterday:', data.completedTasksToday);
```

**Prevention:**
- Complete at least one task daily
- Don't skip days
- Export data regularly (can restore XP/streak)

---

### Issue: App Not Loading

**Symptoms:** Blank page or JavaScript errors.

**Solutions:**

**Check Browser Console:**
1. Press F12
2. Go to "Console" tab
3. Look for red errors

**Common Fixes:**

**Syntax Error After Edit:**
- Restore original file
- Re-apply changes carefully

**Browser Too Old:**
- Update to latest version
- Check [compatibility](#browser-compatibility)

**File Corrupted:**
- Re-download FocusFlow.html
- Import backup data

---

## Performance Optimization

### For Large Task Lists (100+ tasks)

**Problem:** Slow rendering when many tasks present.

**Solution 1: Clear Completed Regularly**
- Use "Clear Completed" button daily
- Only keeps incomplete tasks

**Solution 2: Archive Old Tasks**
- Export current data
- Edit JSON to remove old tasks
- Import cleaned data

**Solution 3: Code Optimization**

Add pagination to task list:
```javascript
// Limit displayed tasks to 50 most recent
function renderTasks() {
    const recentTasks = state.tasks.slice(-50);
    // ... render only recentTasks
}
```

---

### For Low-End Devices

**Reduce Animation:**
```javascript
// Disable confetti (line ~1468)
function launchConfetti() {
    return; // Skip animation
}
```

**Simplify Styles:**
Remove box shadows and gradients:
```css
.panel {
    box-shadow: none; /* Remove */
}
.timer-time {
    background: var(--accent); /* Solid color */
    -webkit-background-clip: unset;
}
```

---

### localStorage Performance

**Current:** Saves entire state on every change.

**Optimization:** Debounce saves:

```javascript
let saveTimeout;
function saveData() {
    clearTimeout(saveTimeout);
    saveTimeout = setTimeout(() => {
        localStorage.setItem('focusflow_data', JSON.stringify(state));
    }, 500); // Wait 500ms of inactivity
}
```

---

## Security Considerations

### Data Privacy

**What's Stored Locally:**
- All tasks (potentially sensitive content)
- All goals
- XP and streak data
- Timer settings

**Risks:**
- Anyone with physical access to device can read localStorage
- Malicious browser extensions could access data
- Shared computers expose data to other users

**Mitigations:**

**Personal Device Only:**
- Don't use on shared/public computers

**Lock Your Computer:**
- Windows: `Win + L`
- macOS: `Ctrl + Cmd + Q`

**Use Browser Profiles:**
- Create separate Chrome profile for work
- FocusFlow data isolated per profile

**Encrypt Sensitive Tasks:**
- Avoid storing passwords/secrets in task text
- Use code names for confidential projects

---

### XSS Protection

**Built-in Protection:**
```javascript
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
```

All user input is escaped before rendering.

**Test:**
Try creating a task:
```
<script>alert('XSS')</script>
```

Should render as literal text, not execute.

---

### localStorage Injection

**Attack Vector:** Malicious script modifying localStorage.

**Protection:**
- Keep browser updated
- Avoid suspicious extensions
- Regular backups (can restore if corrupted)

**Detection:**
Monitor for unexpected data changes:
```javascript
// Integrity check (add to init)
function validateState() {
    if (typeof state.xp !== 'number') {
        alert('Data corruption detected!');
        // Restore from backup
    }
}
```

---

### File Integrity

**For Team Deployment:**

Generate file hash for verification:
```powershell
# PowerShell
Get-FileHash FocusFlow.html -Algorithm SHA256
# Distribute hash to team
# Users verify before using
```

Users verify:
```powershell
Get-FileHash FocusFlow.html -Algorithm SHA256
# Compare with official hash
```

---

## Browser Compatibility

### Fully Supported

| Browser | Minimum Version | Recommended |
|---------|----------------|-------------|
| Chrome | 90+ | Latest |
| Edge | 90+ | Latest |
| Firefox | 88+ | Latest |
| Safari | 14+ | Latest |
| Opera | 76+ | Latest |
| Brave | 1.24+ | Latest |

---

### Feature Support Matrix

| Feature | Chrome | Firefox | Safari | Edge |
|---------|--------|---------|--------|------|
| localStorage | ✅ | ✅ | ✅ | ✅ |
| Notifications | ✅ | ✅ | ✅ | ✅ |
| Web Audio | ✅ | ✅ | ✅ | ✅ |
| Canvas | ✅ | ✅ | ✅ | ✅ |
| File API | ✅ | ✅ | ✅ | ✅ |
| ES6+ | ✅ | ✅ | ✅ | ✅ |
| PWA Install | ✅ | ❌ | ✅ | ✅ |

---

### Known Incompatibilities

**Internet Explorer:**
- ❌ Not supported (ES6 syntax fails)
- No plans for compatibility

**Safari < 14:**
- Partial ES6 support
- Notifications may not work

**Mobile Browsers:**
- ✅ iOS Safari 14+
- ✅ Chrome Android 90+
- ⚠️ Notifications may be limited on iOS

---

### Testing Checklist

Before deploying to team:

- [ ] Task creation works
- [ ] Task completion awards XP
- [ ] Timer counts down accurately
- [ ] Notifications appear (if granted)
- [ ] Export/import works
- [ ] Goals can be created
- [ ] Confetti animation plays
- [ ] Data persists after browser close
- [ ] Responsive layout on mobile
- [ ] No console errors

---

## Maintenance

### Regular Maintenance Tasks

**Weekly:**
- Export backup
- Clear completed tasks (optional)

**Monthly:**
- Review goals progress
- Update motivational quotes (optional)
- Check for browser updates

**Quarterly:**
- Clean localStorage (delete old data)
- Test import/export flow
- Review timer accuracy

---

### Updating FocusFlow

**Process:**
1. Export current data
2. Download new version
3. Replace old file
4. Import data back
5. Test functionality

**Version Control:**

Name files with version:
```
FocusFlow-v1.0.html
FocusFlow-v1.1.html
```

Keep previous version as backup.

---

### Monitoring Data Size

**Check localStorage Usage:**

```javascript
// Browser console
const data = localStorage.getItem('focusflow_data');
const sizeKB = (data.length * 2) / 1024; // Approximate
console.log(`FocusFlow data size: ${sizeKB.toFixed(2)} KB`);
```

**Limits:**
- Most browsers: 5-10 MB localStorage limit
- FocusFlow typically: < 100 KB
- Safe up to ~1000 tasks

**Cleanup:**
- Archive completed tasks
- Export → Edit JSON → Import cleaned data

---

## Advanced Deployment Scenarios

### Corporate Intranet Deployment

**Scenario:** Deploy to 500+ employees on company intranet.

**Setup:**

1. **Host on Intranet Server**
   ```
   \\fileserver\apps\FocusFlow\index.html
   ```

2. **Group Policy Desktop Shortcut**
   - Create GPO
   - Deploy shortcut to all users
   - URL: `file://fileserver/apps/FocusFlow/index.html`

3. **Custom Branding**
   - Replace company logo
   - Customize color scheme
   - Add company-specific quotes

4. **Centralized Analytics (Optional)**
   - Add analytics beacon to track adoption
   - No personal data collection (privacy)

**Example beacon:**
```javascript
// Add to init() function
fetch('https://analytics.company.com/ping', {
    method: 'POST',
    body: JSON.stringify({ app: 'FocusFlow', version: '1.0' })
});
```

---

### Multi-Device Sync (Cloud Backend)

**Scenario:** User wants access from work PC, home PC, and phone.

**Architecture:**

```
┌──────────────┐
│   Device 1   │─────┐
└──────────────┘     │
                     ▼
┌──────────────┐  ┌─────────────┐
│   Device 2   │─→│  Cloud API  │
└──────────────┘  │  (Firebase, │
                  │  Supabase)  │
┌──────────────┐  └─────────────┘
│   Device 3   │─────┘
└──────────────┘
```

**Implementation:**

Add sync layer:
```javascript
// Replace saveData() with cloud sync
async function saveData() {
    // Save locally
    localStorage.setItem('focusflow_data', JSON.stringify(state));
    
    // Sync to cloud
    await fetch('https://api.yourbackend.com/sync', {
        method: 'POST',
        headers: { 'Authorization': 'Bearer ' + userToken },
        body: JSON.stringify(state)
    });
}

// Load from cloud on init
async function loadData() {
    const response = await fetch('https://api.yourbackend.com/data', {
        headers: { 'Authorization': 'Bearer ' + userToken }
    });
    state = await response.json();
}
```

**Recommended Backend:**
- Firebase (Google)
- Supabase (open source)
- Your own REST API

---

### Offline-First PWA

**Add Service Worker:**

**sw.js:**
```javascript
// Cache FocusFlow for offline use
self.addEventListener('install', event => {
    event.waitUntil(
        caches.open('focusflow-v1').then(cache => {
            return cache.addAll(['/FocusFlow.html']);
        })
    );
});

self.addEventListener('fetch', event => {
    event.respondWith(
        caches.match(event.request).then(response => {
            return response || fetch(event.request);
        })
    );
});
```

**Register in FocusFlow.html:**
```javascript
// Add to init()
if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('/sw.js');
}
```

**Result:** App loads even without internet.

---

### Docker Deployment

**Dockerfile:**
```dockerfile
FROM nginx:alpine
COPY FocusFlow.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**Build & Run:**
```bash
docker build -t focusflow .
docker run -d -p 8080:80 focusflow
```

**Access:** `http://localhost:8080`

---

### Electron Desktop App

Package as native desktop app:

**package.json:**
```json
{
  "name": "FocusFlow",
  "version": "1.0.0",
  "main": "main.js",
  "scripts": {
    "start": "electron ."
  },
  "dependencies": {
    "electron": "^25.0.0"
  }
}
```

**main.js:**
```javascript
const { app, BrowserWindow } = require('electron');

app.on('ready', () => {
    const win = new BrowserWindow({
        width: 1400,
        height: 900,
        webPreferences: {
            nodeIntegration: true
        }
    });
    
    win.loadFile('FocusFlow.html');
});
```

**Package:**
```bash
npm install
npm start
electron-packager . FocusFlow --platform=win32 --arch=x64
```

---

## Scaling Considerations

### Single User
- ✅ Works perfectly as-is
- ✅ No modifications needed
- ✅ localStorage sufficient

### Small Team (2-10 users)
- ✅ File share deployment
- ⚠️ Each user has separate data (no sharing)
- ⚠️ Manual backup responsibility

### Medium Team (10-100 users)
- ✅ Intranet deployment
- ✅ Group Policy distribution
- ⚠️ Consider backup education/scripts
- ⚠️ Consider analytics for adoption tracking

### Large Organization (100+ users)
- ⚠️ localStorage limits become concern
- ⚠️ Consider cloud sync solution
- ⚠️ Consider centralized backup
- ⚠️ May need database backend

---

## Support & Resources

### Getting Help

**Self-Service:**
- Re-read this guide
- Check browser console for errors
- Test in different browser
- Try export/import to reset state

**Community:**
- GitHub Issues (if hosted on GitHub)
- Stack Overflow (tag: focusflow)
- Company IT support (for corporate deployments)

---

### Additional Documentation

- **TECHNICAL_ARCHITECTURE.md** - Deep dive into code structure
- **FUNCTIONAL_SPECIFICATION.md** - Feature details and business logic
- **Source Code** - FocusFlow.html is fully commented

---

## Changelog

**v1.0 (Current)**
- Initial release
- Core features: tasks, goals, timer, gamification
- localStorage persistence
- Export/import functionality

**Future Planned Features:**
- Cloud sync
- Mobile app
- Team collaboration
- Advanced analytics

---

## License & Distribution

**Personal Use:** Free, no restrictions

**Corporate Use:** Free for internal use

**Modification:** Allowed, preserve attribution

**Redistribution:** Allowed with attribution

---

## Conclusion

FocusFlow's single-file architecture makes it one of the easiest productivity apps to deploy. Whether you're a solo user double-clicking an HTML file or an IT admin deploying to thousands, the simplicity of the design ensures reliable, maintainable operation.

For most users, simply saving the file and opening it in a browser is sufficient. For power users and organizations, the advanced deployment options provide flexibility without sacrificing the core simplicity that makes FocusFlow special.

**Happy Focusing! 🚀**
