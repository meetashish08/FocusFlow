# 🚀 FocusFlow - Your Daily Productivity Companion

**Stay focused. Stay motivated. Achieve your goals.**

FocusFlow is a beautiful, intuitive productivity tool designed to help you manage daily tasks, achieve long-term goals, and maintain motivation through streaks, XP, and hourly reminders.

---

## ✨ Features

### 📝 Daily Task Management
- **Smart To-Do List** - Add, prioritize, and track your daily tasks
- **Auto-Rollover** - Incomplete tasks automatically move to the next day
- **Priority Levels** - High, Medium, Low priority indicators
- **One-Click Complete** - Check off tasks with satisfying celebrations

### 🌙 Evening Planning
- **Plan Tomorrow** - Dedicated mode for planning next day's tasks (appears after 6 PM)
- **Seamless Rollover** - Tomorrow's tasks become today's tasks automatically
- **Habit Formation** - Build the habit of daily planning

### 🎯 Goal Tracking with Breakdown
- **Long-Term Goals** - Set and track your big objectives
- **Break It Down** - Each goal can have multiple small steps
- **Progress Visualization** - See your progress with beautiful progress bars
- **Quick Action** - Push any goal step directly to today's to-do list
- **Daily Integration** - Connect long-term goals to daily actions

### ⏱️ Pomodoro Focus Timer
- **25/5 Default** - 25 minutes focus, 5 minutes break (customizable)
- **Task Integration** - Select which task you're working on
- **Auto-Tracking** - Completed focus sessions add to your XP
- **Break Reminders** - Automatic break notifications

### 🔥 Streak & Motivation System
- **Daily Streaks** - Track consecutive days of completed tasks
- **XP System** - Earn points for completing tasks and focus sessions
  - +10 XP per task completed
  - +25 XP per focus session
  - +5 XP per goal step completed
  - Bonus XP for streak milestones
- **Level Up** - Your level increases as you earn XP
- **Best Streak** - Remember your longest streak ever

### 💬 Motivational Quotes
- **50+ Curated Quotes** - Inspiring messages to keep you going
- **Daily Rotation** - New quote every session
- **Reminder Integration** - Quotes appear in hourly reminders

### 🎉 Celebrations
- **Confetti Animation** - Beautiful confetti when you complete tasks
- **Sound Effects** - Satisfying audio feedback for actions
- **Encouraging Messages** - Positive reinforcement throughout

### ⏰ Dual Reminder System
- **Hourly Windows Notifications** - Desktop pop-ups every hour (8 AM - 10 PM)
- **In-Browser Reminders** - Notifications when the app is open
- **Motivational Content** - Each reminder includes an inspiring quote

### 💾 Data Management
- **Local Storage** - All data stays private on your computer
- **Export/Import** - Backup and restore your data anytime
- **No Internet Required** - Works completely offline

### 🎨 Beautiful Design
- **Dark Theme** - Easy on the eyes
- **Smooth Animations** - Delightful micro-interactions
- **Responsive Layout** - Works on desktop and tablet
- **Gradient Accents** - Modern, colorful interface

---

## 🚀 Quick Start

### Step 1: Open FocusFlow

1. **Double-click** `FocusFlow.html`
2. It will open in your default browser (Chrome or Edge recommended)
3. **Allow notifications** when prompted (important for reminders!)

### Step 2: Set Up Hourly Reminders

1. **Right-click** on `Setup-FocusFlow-Reminders.ps1`
2. Select **"Run with PowerShell"**
3. If you see a security warning, type `Y` and press Enter
4. The script will:
   - Create a Windows Scheduled Task for hourly reminders
   - Test the notification system
   - Show you confirmation

**Optional:** Add `-AddStartup` flag to make FocusFlow open automatically at login:
```powershell
.\Setup-FocusFlow-Reminders.ps1 -AddStartup
```

### Step 3: Start Using FocusFlow!

**Add Your First Task:**
1. Type a task in "What needs to be done?"
2. Select priority
3. Click "Add" or press Enter

**Set Your First Goal:**
1. Click "+ Add Goal"
2. Enter your goal name
3. Add a small first step
4. Click "Save Goal"

**Start Focusing:**
1. Select a task from the dropdown
2. Click "Start" on the Focus Timer
3. Work for 25 minutes
4. Enjoy your break!

---

## 📖 How to Use

### Daily Workflow

**Morning:**
1. Open FocusFlow (automatically if you added to startup)
2. Review tasks that rolled over from yesterday
3. Add new tasks for today
4. Set priorities

**Throughout the Day:**
1. Check off tasks as you complete them (enjoy the confetti!)
2. Use the Focus Timer for deep work sessions
3. Respond to hourly reminders by checking your progress

**Evening (after 6 PM):**
1. Click "Plan Tomorrow 🌙"
2. Add tasks for the next day
3. Review your goals
4. Feel accomplished!

### Managing Goals

**Create a Goal:**
```
Example: "Learn Spanish"
First step: "Learn 10 new words"
```

**Break It Down:**
- Click on a goal to expand it
- Add small, achievable steps
- Each step can be pushed to today's task list

**Track Progress:**
- Check off steps as you complete them
- Watch the progress bar fill up
- Get XP for each completed step

### Focus Timer Best Practices

1. **Choose One Task** - Select from your task list
2. **Eliminate Distractions** - Close unnecessary tabs
3. **Work Intensely** - 25 minutes of focused work
4. **Take Real Breaks** - Step away from the computer
5. **Repeat** - Build your focus muscle

### Streaks & XP

**Building Streaks:**
- Complete at least 1 task per day
- Open FocusFlow daily
- Streaks reset if you skip a day

**Earning XP:**
- Complete tasks: +10 XP
- Complete focus sessions: +25 XP
- Complete goal steps: +5 XP
- 7-day streak milestone: +50 XP bonus
- Level = √(XP/10)

---

## 🔔 Reminder System Explained

### Windows Desktop Notifications
- **When**: Every hour from 8 AM to 10 PM
- **What**: "⏰ FocusFlow Reminder: Check your tasks and goals!" + motivational quote
- **Works**: Even when browser is closed
- **Setup**: One-time via PowerShell script

### In-Browser Notifications
- **When**: Every hour when FocusFlow tab is open
- **What**: Desktop notification + optional sound
- **Works**: Only while tab is open
- **Setup**: Allow notifications when prompted on first visit

### Test Your Reminders
Click the "🔔 Test Reminder" button in Quick Actions to verify notifications work.

---

## 💾 Backup & Data

### Export Your Data
1. Click "💾 Export Data" in Quick Actions
2. Save the JSON file somewhere safe (e.g., cloud storage)
3. Filename includes date: `focusflow-backup-2026-07-07.json`

### Import Your Data
1. Click "📥 Import Data"
2. Select your backup JSON file
3. Confirm the import
4. All your tasks, goals, streaks, and XP are restored!

### What's Stored
All data is stored in your browser's `localStorage`:
- Today's tasks
- Tomorrow's tasks
- Goals and steps
- Streak and best streak
- Total XP
- Timer settings
- Last open date

**Privacy Note:** Everything stays on your computer. No data is sent anywhere.

---

## ⚙️ Customization

### Timer Settings
- Click the ⚙️ button on the Focus Timer
- Change focus duration (default: 25 minutes)
- Change break duration (default: 5 minutes)
- Settings are saved automatically

### Managing Reminders

**View Scheduled Task:**
```powershell
Get-ScheduledTask -TaskName "FocusFlow Hourly Reminder"
```

**Test Notification Manually:**
```powershell
.\Show-FocusFlow-Reminder.ps1
```

**Remove Reminders:**
```powershell
.\Setup-FocusFlow-Reminders.ps1 -Remove
```

**Re-run Setup:**
```powershell
.\Setup-FocusFlow-Reminders.ps1
```

---

## 🎯 Tips for Maximum Productivity

### 1. The Nightly Planning Habit
Every evening:
- Clear completed tasks
- Review what you accomplished
- Plan tomorrow's 3-5 most important tasks
- Break down one big goal

### 2. Priority Management
- **High**: Must be done today
- **Medium**: Should be done today
- **Low**: Nice to have

Focus on high priority tasks first!

### 3. Goal Breakdown Strategy
Bad goal: "Get fit"
Good goal: "Get fit" → Steps:
- Join a gym
- Work out 3x this week
- Track calories for 7 days
- Learn proper form

### 4. Streak Maintenance
- Set a reminder to open FocusFlow daily
- Complete at least 1 small task per day
- Don't let perfect be the enemy of good
- Even "Review tomorrow's plan" counts!

### 5. Focus Timer Workflow
- **Morning**: 2-3 focus sessions on high-priority tasks
- **Afternoon**: 1-2 focus sessions
- **Evening**: Planning and light tasks

### 6. XP Optimization
- Break large tasks into smaller ones (more XP!)
- Use focus timer for important tasks (+25 XP)
- Check off goal steps as you go (+5 XP each)
- Maintain streaks for bonus XP

---

## 🐛 Troubleshooting

### Notifications Not Showing

**Browser Notifications:**
1. Check browser notification settings
2. Make sure FocusFlow is allowed
3. Chrome: `chrome://settings/content/notifications`
4. Edge: `edge://settings/content/notifications`

**Windows Notifications:**
1. Open Windows Settings
2. System → Notifications
3. Make sure notifications are enabled
4. Find "PowerShell" or "Windows PowerShell" and enable

### Data Not Persisting
- Make sure you're opening the same `FocusFlow.html` file
- Don't use Incognito/Private mode (localStorage won't work)
- Check browser storage settings

### Reminders Not Working
1. Verify task is created:
   ```powershell
   Get-ScheduledTask -TaskName "FocusFlow Hourly Reminder"
   ```
2. Check task history in Task Scheduler
3. Re-run setup script
4. Make sure Windows notification settings allow PowerShell notifications

### Timer Not Starting
- Refresh the page
- Check browser console for errors (F12)
- Make sure you selected a task to focus on

### Confetti/Sounds Not Working
- Check browser permissions
- Make sure sound is not muted
- Some browsers block autoplay audio - click the page first

---

## 📊 Understanding Your Stats

### Streak
- **Current Streak**: Days in a row with completed tasks
- **Best Streak**: Your longest streak ever
- **How to Build**: Complete at least 1 task per day

### XP (Experience Points)
- Measure of total productivity
- Grows forever (never resets)
- Used to calculate level

### Level
- Calculated as: `Level = √(XP/10) + 1`
- Level 1: 0-90 XP
- Level 5: 250+ XP
- Level 10: 1000+ XP

### Tasks Today
- Shows completed vs total
- Resets daily
- Incomplete tasks roll over

---

## 🔄 Keyboard Shortcuts

- **Enter** in task input → Add task
- **Enter** in tomorrow input → Add tomorrow task
- **Enter** in goal step input → Add step
- **Escape** → Close modal (coming soon)

---

## 🌟 Best Practices

1. **Open FocusFlow First Thing** - Make it your morning routine
2. **Plan Your Day** - 3-5 high-impact tasks max
3. **Break Big Goals** - Small steps are achievable steps
4. **Use the Timer** - Deep work sessions are powerful
5. **Review Progress** - Look at your XP and streak growth
6. **Backup Weekly** - Export your data every week
7. **Celebrate Wins** - Enjoy the confetti, you earned it!

---

## 🆘 Support & Feedback

### Getting Help
- Check this README first
- Review the Troubleshooting section
- Check browser console for errors (F12)

### Feature Ideas
FocusFlow is designed to be simple and effective. If you want to add features:
- Open `FocusFlow.html` in a text editor
- The file is self-contained HTML/CSS/JavaScript
- All code is readable and modifiable

---

## 📝 Advanced: Customization

Want to customize FocusFlow? It's just one HTML file!

### Change Colors
Look for the `:root` CSS variables:
```css
--accent: #e94560;  /* Change to your favorite color */
--gradient: linear-gradient(...); /* Customize the gradient */
```

### Add More Quotes
Find the `QUOTES` array in the JavaScript and add your favorites.

### Change Timer Defaults
Modify `focusDuration` and `breakDuration` in the state initialization.

### Add Your Own Features
The code is well-organized with clear sections:
- Data & State
- Initialization
- UI Updates
- Tasks
- Goals
- Timer
- Notifications
- Celebrations
- Data Management

---

## 🎉 You're Ready!

**FocusFlow is now your personal productivity companion.**

Start small:
1. Add 3 tasks for today
2. Set 1 meaningful goal
3. Complete 1 focus session
4. Plan tomorrow evening

Watch your streak grow. Watch your XP climb. Watch yourself achieve more than you thought possible.

**Remember:** Progress, not perfection. Small steps daily. You've got this! 🚀

---

## 📄 Quick Reference Card

```
═══════════════════════════════════════
        FOCUSFLOW QUICK REFERENCE
═══════════════════════════════════════

DAILY ACTIONS:
□ Add today's tasks (3-5 max)
□ Complete at least 1 task
□ Do 1+ focus session
□ Check hourly reminders
□ Plan tomorrow (evening)

GOAL WORKFLOW:
1. Create goal
2. Add small steps
3. Push step → Today
4. Complete & celebrate

FOCUS SESSION:
1. Select task
2. Start timer (25 min)
3. Focus deeply
4. Take break (5 min)
5. Repeat

XP REWARDS:
Task complete     → +10 XP
Focus session     → +25 XP
Goal step         → +5 XP
7-day streak      → +50 XP

REMINDERS:
Every hour, 8 AM - 10 PM
Desktop + Browser notifications

BACKUP:
Export data weekly
Store in cloud backup

═══════════════════════════════════════
        Your only limit is you.
═══════════════════════════════════════
```

---

**Happy focusing! 🚀✨**

*Made with 💜 for productivity enthusiasts*
