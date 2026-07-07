# 🚀 FocusFlow - AI-Powered Daily Productivity Companion

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Made with Love](https://img.shields.io/badge/Made%20with-❤️-red.svg)](https://github.com/meetashish08/FocusFlow)
[![AI Powered](https://img.shields.io/badge/AI-Claude%20Sonnet%204.5-purple.svg)](https://www.anthropic.com/claude)

**Stay focused. Stay motivated. Achieve your goals.**

FocusFlow is a beautiful, intuitive productivity tool that helps you manage daily tasks, achieve long-term goals, and maintain motivation through streaks, XP, hourly reminders, and **AI-powered goal parsing**.

![FocusFlow Screenshot](https://via.placeholder.com/800x400/1a1a2e/ffffff?text=FocusFlow+Dashboard)

---

## ✨ Features

### 🎯 Core Productivity

- **📝 Smart To-Do List** - Add, prioritize, and track tasks with automatic rollover
- **🌙 Evening Planning** - Dedicated mode for planning tomorrow (appears after 6 PM)
- **🎯 Goal Tracking** - Set long-term goals with step-by-step breakdown
- **⏱️ Pomodoro Timer** - Focus sessions with customizable work/break intervals
- **🔥 Streak System** - Track consecutive productive days
- **⭐ XP & Leveling** - Earn points and level up as you complete tasks
- **💬 Motivational Quotes** - 50+ inspiring messages to keep you going
- **🎉 Celebrations** - Confetti and sounds when you achieve milestones

### ✨ AI-Powered Features (NEW!)

- **🤖 AI Goal Parser** - Describe goals naturally, AI breaks them into actionable steps
- **💡 Smart Suggestions** - AI identifies potential improvements to your goals
- **🎯 Daily Action Items** - AI suggests what to start today
- **⚡ Enhancement Mode** - Get expert tips, identify obstacles, and solutions

### ⏰ Reminder System

- **Desktop Notifications** - Hourly Windows pop-ups (8 AM - 10 PM)
- **In-Browser Reminders** - Notifications when tab is open
- **Motivational Content** - Each reminder includes an inspiring quote

### 💾 Data & Privacy

- **100% Offline** - Works without internet (except AI features)
- **Local Storage** - All data stays on your computer
- **Export/Import** - Backup and restore anytime
- **No Tracking** - Zero analytics or external tracking

---

## 🚀 Quick Start

### Option 1: Direct Use (Simplest)

1. **Download** `FocusFlow.html`
2. **Double-click** to open in browser
3. **Allow notifications** when prompted
4. **Start being productive!**

### Option 2: With Hourly Reminders

1. Download `FocusFlow.html` and `Setup-FocusFlow-Reminders.ps1`
2. Open `FocusFlow.html` in browser
3. Right-click `Setup-FocusFlow-Reminders.ps1` → "Run with PowerShell"
4. You'll now get hourly desktop reminders!

### Option 3: Auto-Start on Login

```powershell
.\Setup-FocusFlow-Reminders.ps1 -AddStartup
```

---

## 📖 Documentation

- **[Quick Setup Guide](QUICK_SETUP.txt)** - 3-minute setup
- **[Complete README](FocusFlow_README.md)** - Full user manual
- **[Visual Guide](FocusFlow_Visual_Guide.md)** - Interface diagrams
- **[Technical Architecture](docs/TECHNICAL_ARCHITECTURE.md)** - System design
- **[Functional Spec](docs/FUNCTIONAL_SPECIFICATION.md)** - Feature details
- **[Deployment Guide](docs/DEPLOYMENT_GUIDE.md)** - Installation & ops
- **[AI Feature Guide](docs/AI_FEATURE_GUIDE.md)** - AI goal parser documentation

---

## 🤖 AI Goal Parser

### How It Works

1. **Describe your goal** naturally in your own words
2. **AI analyzes** and structures it into actionable steps
3. **Review & enhance** with expert tips and obstacle solutions
4. **Create goal** - integrated seamlessly into FocusFlow

### Example

**Your Input:**
> "I want to learn Spanish fluently so I can travel to Spain next year. I need to improve my vocabulary, grammar, and conversation skills."

**AI Output:**
```
Goal: Learn Spanish Fluently

Steps:
✅ Enroll in online Spanish course
✅ Practice vocabulary 15 minutes daily
✅ Complete grammar exercises weekly
✅ Join language exchange meetup
✅ Watch Spanish TV shows with subtitles

💡 Suggestion: Start with basics before advanced grammar

🎯 Start Today: Download Duolingo and complete first lesson
```

**Powered by:** Claude Sonnet 4.5 via Portkey API

---

## 🎯 How to Use

### Daily Workflow

**Morning:**
1. Open FocusFlow
2. Review tasks that rolled over
3. Add 3-5 new tasks for today
4. Set priorities

**Throughout the Day:**
1. Check off tasks (enjoy confetti!)
2. Use Focus Timer for deep work
3. Respond to hourly reminders

**Evening (after 6 PM):**
1. Click "Plan Tomorrow 🌙"
2. Add tasks for the next day
3. Review your goals
4. Feel accomplished!

### Goal Breakdown

**Manual Mode:**
- Click "+ Add Goal"
- Enter goal name and first step
- Add more steps as you go

**AI Mode (Recommended):**
- Click "✨ AI Goal"
- Describe your goal naturally
- AI breaks it down for you
- Review, enhance, create!

---

## 💡 Best Practices

### The 3-5 Rule
- Add max 3-5 tasks per day
- Focus on impact, not quantity
- Quality over quantity

### Goal Staircase
```
Big Goal (e.g., "Get fit")
  └─> Monthly Milestone ("Workout 12x")
      └─> Weekly Step ("Gym 3x this week")
          └─> Daily Action ("30 min workout today")
```

### Streak Strategy
- Complete at least 1 task daily
- Open FocusFlow first thing
- Celebrate every check-off
- Use AI to break big goals into small wins

---

## 🎨 Screenshots

### Main Dashboard
```
┌────────────────────────────────────────────────────────┐
│ 🚀 FocusFlow              July 7, 2026                │
├────────────────────────────────────────────────────────┤
│  🔥 5 Days    ⭐ 230 XP    📊 Level 6    ✅ 3/5 Tasks │
└────────────────────────────────────────────────────────┘

"Your only limit is you."

┌─────────────────────┬────────────────────────────┐
│ 📝 Today's Tasks    │ ⏱️ Focus Timer            │
│                     │                            │
│ ☐ Write report      │      24:35                 │
│ ☐ Review budget     │                            │
│ ☑ Morning exercise  │   [▶ Start] [⏸] [↻]      │
└─────────────────────┴────────────────────────────┘
```

### AI Goal Parser
```
┌──────────────────────────────────────────────────┐
│ ✨ AI Goal Parser                           ✕   │
├──────────────────────────────────────────────────┤
│ Describe your goal in your own words...         │
│ ┌──────────────────────────────────────────┐   │
│ │ I want to learn Spanish fluently...      │   │
│ └──────────────────────────────────────────┘   │
│                                                  │
│           [✨ Parse with AI]                    │
│                                                  │
│ 📋 Parsed Goal: Learn Spanish Fluently          │
│ ✅ 5 actionable steps                           │
│ 💡 Expert suggestions                           │
│ 🎯 Daily task to start today                    │
└──────────────────────────────────────────────────┘
```

---

## 📊 Tech Stack

- **Frontend:** Pure HTML5, CSS3, JavaScript (ES6+)
- **Storage:** Browser localStorage
- **AI:** Claude Sonnet 4.5 (Anthropic) via Portkey
- **Notifications:** Web Notifications API + Windows Task Scheduler
- **Architecture:** Single-file application (no build process)

---

## 🔧 Configuration

### Customize Timer
```javascript
// In FocusFlow.html, find:
settings: {
    focusDuration: 25,  // minutes
    breakDuration: 5    // minutes
}
```

### Change Colors
```css
/* In FocusFlow.html, :root section: */
:root {
    --accent: #e94560;  /* Change to your color */
    --gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
```

### Add Quotes
```javascript
// In FocusFlow.html, QUOTES array:
const QUOTES = [
    "Your only limit is you.",
    // Add more here...
];
```

### Configure AI
```javascript
// In FocusFlow.html, PORTKEY_CONFIG:
const PORTKEY_CONFIG = {
    baseURL: 'https://api.portkey.ai',
    apiKey: 'YOUR_API_KEY',  // Replace with yours
    defaultModel: '@vertexai-global/anthropic.claude-sonnet-4-5@20250929'
};
```

---

## 🐛 Troubleshooting

### Notifications Not Working

**Browser:**
1. Settings → Notifications → Allow FocusFlow

**Windows:**
1. Settings → Notifications → Enable for PowerShell

### Data Not Saving
- Don't use Incognito mode
- Open same FocusFlow.html file each time
- Check browser storage settings

### AI Parser Not Working
- Check internet connection
- Verify Portkey API key
- Check browser console (F12) for errors

### Reminders Not Appearing
```powershell
# Check task exists
Get-ScheduledTask -TaskName "FocusFlow Hourly Reminder"

# Re-run setup
.\Setup-FocusFlow-Reminders.ps1
```

---

## 📈 Roadmap

### v1.0 (Current)
- ✅ Core task management
- ✅ Goal tracking with breakdown
- ✅ Pomodoro timer
- ✅ Streak & XP system
- ✅ Hourly reminders
- ✅ AI goal parser
- ✅ Export/import data

### v1.1 (Planned)
- [ ] Multi-language support
- [ ] Cloud sync (optional)
- [ ] Calendar integration
- [ ] Team goals (shared)
- [ ] Mobile app (PWA)
- [ ] Voice input for AI goals
- [ ] Weekly/monthly reports
- [ ] Custom themes

### v2.0 (Future)
- [ ] AI coach mode (weekly check-ins)
- [ ] Habit tracking
- [ ] Time analytics
- [ ] Collaboration features
- [ ] Browser extension
- [ ] Desktop app (Electron)

---

## 🤝 Contributing

Contributions are welcome! Here's how:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly
5. Commit with clear message (`git commit -m 'Add amazing feature'`)
6. Push to branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Development Guidelines

- Keep it simple and fast
- Maintain single-file architecture
- No external dependencies
- Test on Chrome, Edge, Firefox
- Document new features

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

**TL;DR:** Free to use, modify, and distribute. Just keep the attribution.

---

## 🙏 Acknowledgments

- **Claude AI** by Anthropic - Powers the AI goal parser
- **Portkey** - API gateway for AI integration
- **You!** - For wanting to be more productive

---

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/meetashish08/FocusFlow/issues)
- **Discussions:** [GitHub Discussions](https://github.com/meetashish08/FocusFlow/discussions)
- **Email:** meetashish08@gmail.com

---

## 🌟 Star This Repo!

If FocusFlow helps you achieve your goals, please ⭐ star this repository!

---

## 📊 Stats

![GitHub stars](https://img.shields.io/github/stars/meetashish08/FocusFlow?style=social)
![GitHub forks](https://img.shields.io/github/forks/meetashish08/FocusFlow?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/meetashish08/FocusFlow?style=social)

---

## 💖 Built With Love

FocusFlow is built with 💜 for productivity enthusiasts who want to:
- ✅ Get more done
- ✅ Stay focused
- ✅ Achieve their goals
- ✅ Build consistent habits
- ✅ Level up their life

**Your only limit is you. Now go make it happen.** 🚀

---

*Made with ✨ by [Ashish Kumar](https://github.com/meetashish08)*

*Powered by Claude Sonnet 4.5*
