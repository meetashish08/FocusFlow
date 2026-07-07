# ⚡ FocusFlow - Quick Access Guide

**Choose your preferred method based on your workflow:**

---

## 🏆 **Method 1: Desktop Shortcut** (Best for Daily Use)

### Setup (One-time - 30 seconds)

**Option A: Automatic Setup**
```powershell
# Download and create desktop shortcut
cd $env:USERPROFILE\Desktop
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/meetashish08/FocusFlow/main/FocusFlow.html" -OutFile "FocusFlow.html"

# Create shortcut
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\🚀 FocusFlow.lnk")
$Shortcut.TargetPath = "$env:USERPROFILE\Desktop\FocusFlow.html"
$Shortcut.Save()
```

**Option B: Manual Setup**
1. Download `FocusFlow.html` from GitHub
2. Save to Desktop
3. Right-click → Create Shortcut
4. Rename to "🚀 FocusFlow"

### Daily Usage
- **Double-click** desktop icon
- Opens in default browser
- Allow notifications when prompted

**Pros:**
- ✅ Fastest access (desktop icon)
- ✅ Works offline
- ✅ Data stays local
- ✅ No login required

**Cons:**
- ❌ Manual updates needed

---

## 🌐 **Method 2: GitHub Pages URL** (Best for Multiple Devices)

### Setup (One-time - 1 minute)

**Step 1: Enable GitHub Pages**
1. Go to: https://github.com/meetashish08/FocusFlow
2. Click **Settings** tab
3. Scroll to **Pages** section
4. Source: Deploy from `main` branch
5. Folder: `/ (root)`
6. Click **Save**

**Step 2: Get Your URL**

After 1-2 minutes, your FocusFlow will be live at:
```
https://meetashish08.github.io/FocusFlow/
```

**Step 3: Bookmark It**
```
Chrome/Edge:
1. Visit the URL
2. Press Ctrl+D
3. Name: "🚀 FocusFlow"
4. Save to Bookmarks Bar
```

### Daily Usage
- Click bookmark in browser
- Or visit: `https://meetashish08.github.io/FocusFlow/`

**Pros:**
- ✅ Access from any device
- ✅ Always latest version
- ✅ Shareable URL
- ✅ No download needed

**Cons:**
- ❌ Requires internet for AI features
- ❌ Data stored per-browser (use Export/Import)

---

## 📌 **Method 3: Browser New Tab** (Best for Constant Access)

### Setup (30 seconds)

**Chrome:**
1. Install extension: "Custom New Tab URL"
2. Set URL to your local file or GitHub Pages URL
3. Every new tab = FocusFlow

**Edge:**
1. Settings → Appearance → Open new tabs with
2. Select "Custom URL"
3. Enter: File path or GitHub Pages URL

**Manual Alternative:**
1. Open `FocusFlow.html` locally
2. Pin the tab (right-click → Pin tab)
3. Tab stays open across sessions

### Daily Usage
- Open browser = FocusFlow ready
- Or press Ctrl+T for new tab

**Pros:**
- ✅ Always visible
- ✅ No clicking needed
- ✅ Part of workflow

**Cons:**
- ❌ Takes up tab space (if not pinned)

---

## 🖥️ **Method 4: Windows Startup** (Best for Morning Routine)

### Setup (1 minute)

```powershell
# Create startup shortcut
$StartupFolder = [Environment]::GetFolderPath('Startup')
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$StartupFolder\FocusFlow.lnk")
$Shortcut.TargetPath = "$env:USERPROFILE\Desktop\FocusFlow.html"
$Shortcut.Save()

Write-Host "✅ FocusFlow will now open on Windows startup!"
```

**OR use the setup script:**
```powershell
.\Setup-FocusFlow-Reminders.ps1 -AddStartup
```

### Daily Usage
- Log into Windows
- FocusFlow opens automatically
- Start planning your day immediately

**Pros:**
- ✅ Zero effort daily
- ✅ Part of morning routine
- ✅ Never forget to check

**Cons:**
- ❌ Opens every login (can disable if needed)

---

## 🔗 **Method 5: Quick Launch Toolbar** (Windows Power Users)

### Setup (20 seconds)

1. Right-click Taskbar → Toolbars → New Toolbar
2. Browse to FocusFlow folder
3. Select the folder
4. FocusFlow appears in taskbar

### Daily Usage
- Click taskbar icon
- Access from anywhere

**Pros:**
- ✅ Always visible
- ✅ One-click access
- ✅ Minimal space

---

## 🎯 **Recommended Setup for Maximum Productivity**

### **The "No-Friction" Combo:**

1. **Local File** on Desktop (instant access)
2. **Pin Browser Tab** (always visible)
3. **Hourly Reminders** (never forget)
4. **Bookmark** for backup access

### Setup Script (Copy & Run):

```powershell
# Complete FocusFlow Setup
Write-Host "🚀 Setting up FocusFlow for maximum productivity..." -ForegroundColor Cyan

# 1. Download to Desktop
cd $env:USERPROFILE\Desktop
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/meetashish08/FocusFlow/main/FocusFlow.html" -OutFile "FocusFlow.html"
Write-Host "✅ Downloaded to Desktop" -ForegroundColor Green

# 2. Create Desktop Shortcut
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\🚀 FocusFlow.lnk")
$Shortcut.TargetPath = "$env:USERPROFILE\Desktop\FocusFlow.html"
$Shortcut.Save()
Write-Host "✅ Desktop shortcut created" -ForegroundColor Green

# 3. Open in Browser
start chrome "$env:USERPROFILE\Desktop\FocusFlow.html"
Write-Host "✅ Opened in browser" -ForegroundColor Green

Write-Host ""
Write-Host "📋 Next Steps:" -ForegroundColor Yellow
Write-Host "1. Allow notifications when prompted"
Write-Host "2. Press Ctrl+D to bookmark"
Write-Host "3. Right-click tab → Pin tab"
Write-Host "4. Run Setup-FocusFlow-Reminders.ps1 for hourly reminders"
Write-Host ""
Write-Host "🎉 FocusFlow is ready to boost your productivity!" -ForegroundColor Green
```

---

## 🔄 **Keeping FocusFlow Updated**

### Auto-Update Script (Run Weekly):

```powershell
# Update FocusFlow to latest version
Write-Host "🔄 Updating FocusFlow..." -ForegroundColor Cyan

$LocalFile = "$env:USERPROFILE\Desktop\FocusFlow.html"
$GitHubURL = "https://raw.githubusercontent.com/meetashish08/FocusFlow/main/FocusFlow.html"

# Backup current version
if (Test-Path $LocalFile) {
    Copy-Item $LocalFile "$LocalFile.backup"
    Write-Host "✅ Backed up current version" -ForegroundColor Green
}

# Download latest
Invoke-WebRequest -Uri $GitHubURL -OutFile $LocalFile
Write-Host "✅ Updated to latest version" -ForegroundColor Green

Write-Host ""
Write-Host "💡 Your data is safe (stored in browser, not in the file)" -ForegroundColor Yellow
Write-Host "🎉 FocusFlow is now up to date!" -ForegroundColor Green
```

---

## 📊 **Comparison Chart**

| Method | Speed | Offline | Updates | Multi-Device | Setup Time |
|--------|-------|---------|---------|--------------|------------|
| Desktop Shortcut | ⚡⚡⚡ | ✅ | Manual | ❌ | 30 sec |
| GitHub Pages | ⚡⚡ | ❌ | Auto | ✅ | 1 min |
| Browser New Tab | ⚡⚡⚡ | ✅ | Manual | ❌ | 30 sec |
| Windows Startup | ⚡⚡⚡ | ✅ | Manual | ❌ | 1 min |
| Quick Launch | ⚡⚡⚡ | ✅ | Manual | ❌ | 20 sec |

---

## 💡 **Pro Tips**

### 1. **Multiple Access Points**
Set up 2-3 methods:
- Desktop shortcut (primary)
- Bookmark (backup)
- Pinned tab (always visible)

### 2. **Data Backup**
```powershell
# Weekly backup (add to Task Scheduler)
# Open FocusFlow → Click "Export Data" → Save to cloud folder
```

### 3. **Keyboard Shortcut** (Advanced)
Create AutoHotkey script:
```ahk
^!f::  ; Ctrl+Alt+F opens FocusFlow
Run, C:\Users\YourName\Desktop\FocusFlow.html
return
```

### 4. **Mobile Access**
- Upload `FocusFlow.html` to cloud (OneDrive, Dropbox)
- Open from mobile browser
- Add to home screen (works like an app!)

---

## 🎯 **Recommended: The "2-Second Setup"**

**For maximum productivity with minimum friction:**

```powershell
# Run this ONE command:
cd $env:USERPROFILE\Desktop; Invoke-WebRequest -Uri "https://raw.githubusercontent.com/meetashish08/FocusFlow/main/FocusFlow.html" -OutFile "FocusFlow.html"; start chrome "FocusFlow.html"
```

**Then:**
1. Allow notifications
2. Ctrl+D to bookmark
3. Right-click tab → Pin tab
4. Done! 🎉

---

## 🚀 **Access URLs**

### GitHub Repository
```
https://github.com/meetashish08/FocusFlow
```

### GitHub Pages (Once enabled)
```
https://meetashish08.github.io/FocusFlow/
```

### Raw File (Direct download)
```
https://raw.githubusercontent.com/meetashish08/FocusFlow/main/FocusFlow.html
```

---

## 📞 **Need Help?**

**Can't access FocusFlow?**
1. Check browser allows local HTML files
2. Enable notifications in browser settings
3. Clear browser cache (Ctrl+Shift+Delete)

**Data not saving?**
- Don't use Incognito mode
- Check browser storage permissions
- Make sure you're opening the same file

**AI features not working?**
- Check internet connection
- Verify Portkey API key in settings
- Check browser console (F12) for errors

---

## 🎉 **You're All Set!**

Choose your preferred method and start boosting your productivity!

**Recommended for most users:**
→ Desktop Shortcut + Pinned Browser Tab + Hourly Reminders

**Takes 2 minutes to setup, saves hours of productivity! 🚀**
