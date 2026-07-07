# FocusFlow Technical Architecture

## Table of Contents
- [Overview](#overview)
- [High-Level Architecture](#high-level-architecture)
- [Component Breakdown](#component-breakdown)
- [Data Flow](#data-flow)
- [localStorage Schema](#localstorage-schema)
- [State Management](#state-management)
- [Event Handling Architecture](#event-handling-architecture)
- [Timer Implementation](#timer-implementation)
- [Notification System](#notification-system)
- [UI Rendering Pipeline](#ui-rendering-pipeline)

---

## Overview

FocusFlow is a zero-dependency, single-file HTML productivity application built with vanilla JavaScript, CSS, and HTML5. The entire application (~1600 lines) is self-contained in a single HTML file, making it extremely portable and easy to deploy.

**Key Technical Characteristics:**
- **Architecture Pattern:** MVC-like pattern with state-driven rendering
- **Data Persistence:** Browser localStorage (JSON serialization)
- **Styling:** CSS3 with CSS Custom Properties (variables)
- **JavaScript:** ES6+ (arrow functions, destructuring, template literals)
- **APIs Used:** Web Audio API, Notification API, Canvas API, File API
- **No Build Process:** Runs directly in browser, no compilation needed
- **No External Dependencies:** Pure vanilla JavaScript

---

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      FocusFlow.html                         │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │                    HTML Structure                     │ │
│  │  - Header (Stats, Date)                              │ │
│  │  - Main Grid (Tasks, Timer, Goals, Quick Actions)    │ │
│  │  - Modals (Add Goal, Plan Tomorrow, Settings)        │ │
│  │  - Canvas (Confetti animations)                      │ │
│  └───────────────────────────────────────────────────────┘ │
│                            │                                │
│  ┌───────────────────────────────────────────────────────┐ │
│  │                    CSS Styling                        │ │
│  │  - CSS Variables (Theme colors)                      │ │
│  │  - Component Styles (Cards, Buttons, Inputs)         │ │
│  │  - Animations (Pulse, Hover effects)                 │ │
│  │  - Responsive Grid Layout                            │ │
│  └───────────────────────────────────────────────────────┘ │
│                            │                                │
│  ┌───────────────────────────────────────────────────────┐ │
│  │                JavaScript Logic                       │ │
│  │                                                       │ │
│  │  ┌─────────────┐  ┌──────────────┐  ┌────────────┐  │ │
│  │  │   State     │──│   Storage    │──│ localStorage││ │
│  │  │  Management │  │   Layer      │  │             │  │ │
│  │  └─────────────┘  └──────────────┘  └────────────┘  │ │
│  │         │                                            │ │
│  │  ┌─────────────────────────────────────────────┐    │ │
│  │  │         Business Logic Modules              │    │ │
│  │  │  - Tasks  - Goals  - Timer  - Gamification  │    │ │
│  │  └─────────────────────────────────────────────┘    │ │
│  │         │                                            │ │
│  │  ┌─────────────────────────────────────────────┐    │ │
│  │  │          UI Rendering Layer                 │    │ │
│  │  │  - renderTasks()  - renderGoals()           │    │ │
│  │  │  - updateStats()  - updateTimerDisplay()    │    │ │
│  │  └─────────────────────────────────────────────┘    │ │
│  │         │                                            │ │
│  │  ┌─────────────────────────────────────────────┐    │ │
│  │  │         Browser APIs Layer                  │    │ │
│  │  │  - Notification - Canvas - Web Audio - File │    │ │
│  │  └─────────────────────────────────────────────┘    │ │
│  └───────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## Component Breakdown

### 1. HTML Structure (Lines 1-700)

The application is divided into logical sections:

```
├── <head>
│   ├── Meta tags (viewport, charset)
│   └── <style> - All CSS in one block
│
├── <body>
│   ├── <canvas id="confetti-canvas"> - Celebration animations
│   │
│   ├── <div class="container"> - Main app container
│   │   ├── Header Section
│   │   │   ├── Title & Date
│   │   │   └── Stats Row (Streak, XP, Level, Tasks)
│   │   │
│   │   ├── Quote Section
│   │   │
│   │   ├── Evening Banner (conditional)
│   │   │
│   │   └── Main Grid (2-column responsive)
│   │       ├── Today's Tasks Panel
│   │       ├── Focus Timer Panel
│   │       ├── Goals Panel
│   │       └── Quick Actions Panel
│   │
│   └── Modals (overlay dialogs)
│       ├── Add Goal Modal
│       ├── Plan Tomorrow Modal
│       └── Timer Settings Modal
│
└── <script> - All JavaScript logic
```

### 2. CSS Architecture (Lines 7-551)

**Design System:**
```css
:root {
  --bg-primary: #1a1a2e;      /* Main background */
  --bg-secondary: #16213e;    /* Panel backgrounds */
  --bg-card: #0f3460;         /* Card/input backgrounds */
  --accent: #e94560;          /* Primary accent (pink) */
  --accent-light: #ff6b8a;    /* Hover states */
  --text-primary: #eee;       /* Main text */
  --text-secondary: #aaa;     /* Secondary text */
  --success: #00d4aa;         /* Success states */
  --warning: #ffd93d;         /* Warning states */
  --gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
```

**Component Hierarchy:**
1. **Base Reset** (lines 8-12): Zero margins, border-box sizing
2. **Layout Components**: Container, Grid, Panels
3. **UI Elements**: Buttons, Inputs, Cards
4. **Feature Components**: Tasks, Goals, Timer
5. **Utilities**: Modals, Scrollbars, Animations

### 3. JavaScript Architecture (Lines 775-1617)

**Module Organization:**

```javascript
// ============ DATA & STATE ============
QUOTES[]                    // 50+ motivational quotes
state {}                    // Global application state
timerInterval               // Timer tick interval
reminderInterval            // Hourly reminder interval

// ============ INITIALIZATION ============
init()                      // Bootstrap application
loadData()                  // Load from localStorage
saveData()                  // Persist to localStorage
checkAndRolloverTasks()     // Daily rollover logic

// ============ UI UPDATES ============
updateUI()                  // Master UI update
updateStats()               // Header stats
renderTasks()               // Task list rendering
renderGoals()               // Goals rendering
updateTimerDisplay()        // Timer display

// ============ TASKS ============
addTask()                   // Create new task
toggleTask()                // Mark complete/incomplete
deleteTask()                // Remove task
clearCompleted()            // Bulk removal

// ============ TOMORROW TASKS ============
addTomorrowTask()           // Plan for tomorrow
openPlanTomorrow()          // Modal controller
checkEveningMode()          // 6PM-11PM banner

// ============ GOALS ============
openAddGoal()               // Goal creation modal
saveGoal()                  // Persist new goal
addGoalStep()               // Add step to goal
toggleGoalStep()            // Mark step complete
pushStepToToday()           // Convert step → task

// ============ TIMER ============
startTimer()                // Begin focus session
pauseTimer()                // Pause session
resetTimer()                // Reset to initial state
updateTimer()               // Tick handler (1 second)
timerComplete()             // Completion logic

// ============ NOTIFICATIONS ============
requestNotificationPermission()
setupHourlyReminder()       // Schedule reminders
showReminder()              // Display notification
testReminder()              // Manual trigger

// ============ CELEBRATIONS ============
celebrate()                 // Task completion fanfare
celebrateStreak()           // Streak milestone
launchConfetti()            // Canvas animation

// ============ SOUNDS ============
playSound(type)             // Web Audio synthesis

// ============ DATA MANAGEMENT ============
exportData()                // Download JSON backup
importData()                // Upload JSON backup

// ============ UTILITIES ============
closeModal()                // Modal controls
escapeHtml()                // XSS prevention
```

---

## Data Flow

### Application Boot Flow

```
┌─────────────────────────────────────────────────────────────┐
│                  Browser Loads HTML File                    │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   ▼
         ┌─────────────────────┐
         │  DOMContentLoaded   │
         │  Event Fires        │
         └──────────┬──────────┘
                    │
                    ▼
            ┌───────────────┐
            │   init()      │
            └───────┬───────┘
                    │
        ┌───────────┼───────────┐
        │           │           │
        ▼           ▼           ▼
   loadData()  checkRollover  updateUI()
   (localStorage)    │            │
        │            │            │
        │            ▼            │
        │    Daily Logic Check   │
        │    - Streak calc       │
        │    - Roll incomplete   │
        │    - Add tomorrow      │
        │            │            │
        └────────────┴────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
        ▼                         ▼
  showRandomQuote()    requestNotificationPermission()
        │                         │
        ▼                         ▼
  setupHourlyReminder()    checkEveningMode()
        │
        ▼
  ┌──────────────────────────┐
  │  Application Ready       │
  │  - UI Rendered           │
  │  - Timers Armed          │
  │  - Event Listeners Live  │
  └──────────────────────────┘
```

### Task Completion Flow

```
User Clicks Checkbox
        │
        ▼
  toggleTask(id)
        │
   ┌────┴────┐
   │  Find   │
   │  Task   │
   └────┬────┘
        │
  ┌─────▼─────┐
  │  Toggle   │ 
  │ completed │
  │   flag    │
  └─────┬─────┘
        │
   Was Checked?
        │
    ┌───┴───┐
    │ YES   │
    ▼       │
  Add XP    │
  Increment │
  Counter   │
    │       │
  celebrate()
  playSound()
    │       │
    └───┬───┘
        │
        ▼
    saveData()
        │
        ▼
   renderTasks()
        │
        ▼
   updateStats()
```

### Daily Rollover Flow

```
      App Opens (init)
            │
            ▼
   checkAndRolloverTasks()
            │
     ┌──────┴──────┐
     │ Get Today's │
     │    Date     │
     └──────┬──────┘
            │
      ┌─────▼──────┐
      │ Same as    │◄─── YES ─── Do Nothing
      │ lastOpen?  │
      └─────┬──────┘
            │
           NO
            │
      ┌─────▼─────────────┐
      │ Calculate Days    │
      │ Since Last Open   │
      └─────┬─────────────┘
            │
      ┌─────▼──────────────────────┐
      │ Had Tasks Yesterday?       │
      │ && Exactly 1 Day Passed?   │
      └─────┬──────────────────────┘
            │
        ┌───┴───┐
       YES      NO
        │        │
        ▼        ▼
  Increment  Reset Streak
   Streak    (Missed Day)
        │        │
        └───┬────┘
            │
      ┌─────▼──────────────┐
      │ Filter Tasks:      │
      │ Keep Incomplete    │
      │ Discard Completed  │
      └─────┬──────────────┘
            │
      ┌─────▼──────────────┐
      │ Move Tomorrow      │
      │ Tasks → Today      │
      └─────┬──────────────┘
            │
      ┌─────▼──────────────┐
      │ Update lastOpenDate│
      │ Reset completedCtr │
      └─────┬──────────────┘
            │
            ▼
        saveData()
```

---

## localStorage Schema

### Storage Key
```
focusflow_data
```

### Data Structure

```javascript
{
  // ============ TASKS ============
  "tasks": [
    {
      "id": 1720534567890,           // Unix timestamp
      "text": "Complete documentation",
      "priority": "high",             // "low" | "medium" | "high"
      "completed": false,             // boolean
      "createdAt": "2024-07-09T10:30:00.000Z"
    }
  ],
  
  // ============ TOMORROW TASKS ============
  "tomorrowTasks": [
    {
      "id": 1720534600000,
      "text": "Review pull requests",
      "priority": "medium",
      "completed": false
    }
  ],
  
  // ============ GOALS ============
  "goals": [
    {
      "id": 1720534700000,
      "name": "Learn Spanish",
      "steps": [
        {
          "id": 1720534701000,
          "text": "Learn 10 new words",
          "completed": false
        },
        {
          "id": 1720534702000,
          "text": "Practice conversation 15min",
          "completed": true
        }
      ],
      "createdAt": "2024-07-09T10:45:00.000Z"
    }
  ],
  
  // ============ GAMIFICATION ============
  "streak": 5,                        // Current consecutive days
  "bestStreak": 12,                   // All-time best streak
  "xp": 450,                          // Total experience points
  "completedTasksToday": 3,           // Count for today
  
  // ============ METADATA ============
  "lastOpenDate": "Tue Jul 09 2024",  // Date string format
  
  // ============ SETTINGS ============
  "settings": {
    "focusDuration": 25,              // Minutes
    "breakDuration": 5,               // Minutes
    "notificationsEnabled": true      // Permission state
  },
  
  // ============ TIMER STATE ============
  "timer": {
    "isRunning": false,
    "isPaused": false,
    "timeLeft": 1500,                 // Seconds
    "focusTask": {                    // Reference to task or null
      "id": 1720534567890,
      "text": "Complete documentation"
    },
    "mode": "focus"                   // "focus" | "break"
  }
}
```

### Storage Operations

**Read:**
```javascript
const saved = localStorage.getItem('focusflow_data');
const data = saved ? JSON.parse(saved) : null;
```

**Write:**
```javascript
localStorage.setItem('focusflow_data', JSON.stringify(state));
```

**Size Limit:** Most browsers provide 5-10MB for localStorage. FocusFlow typically uses <100KB.

---

## State Management

### Global State Object

```javascript
let state = {
  tasks: [],              // Array<Task>
  tomorrowTasks: [],      // Array<Task>
  goals: [],              // Array<Goal>
  streak: 0,              // number
  bestStreak: 0,          // number
  xp: 0,                  // number
  lastOpenDate: null,     // string | null
  completedTasksToday: 0, // number
  settings: {
    focusDuration: 25,
    breakDuration: 5,
    notificationsEnabled: false
  },
  timer: {
    isRunning: false,
    isPaused: false,
    timeLeft: 1500,
    focusTask: null,
    mode: 'focus'
  }
};
```

### State Update Pattern

FocusFlow follows a simple **imperative state mutation** pattern:

1. **Mutate State** directly (no immutability enforced)
2. **Persist** via `saveData()`
3. **Re-render** affected UI components

Example:
```javascript
function addTask() {
  // 1. Mutate
  state.tasks.push(newTask);
  
  // 2. Persist
  saveData();
  
  // 3. Re-render
  renderTasks();
  updateTimerTaskSelect();
}
```

### State Synchronization Points

**On Load:**
- `loadData()` → Hydrates state from localStorage
- `checkAndRolloverTasks()` → Applies daily logic
- `updateUI()` → Renders initial view

**On User Action:**
- Individual handlers mutate state
- `saveData()` called immediately
- Specific render functions called

**On Timer Tick:**
- `updateTimer()` → Mutates `state.timer.timeLeft`
- `updateTimerDisplay()` → Updates DOM
- No persistence needed (ephemeral state)

**Before Unload:**
- `beforeunload` event → Final `saveData()` call

---

## Event Handling Architecture

### Event Binding Strategy

FocusFlow uses **inline event handlers** (not addEventListener). This is acceptable for a small single-file app but wouldn't scale to larger projects.

```html
<!-- Inline onclick -->
<button onclick="addTask()">Add</button>

<!-- Inline onchange -->
<input onchange="toggleTask(123)" type="checkbox">

<!-- Inline onkeypress -->
<input onkeypress="handleTaskEnter(event)">
```

### Event Flow Map

```
┌────────────────────────────────────────────────────────┐
│                    User Interactions                   │
└──────────────┬─────────────────────────────────────────┘
               │
     ┌─────────┼─────────────────────┐
     │         │                     │
     ▼         ▼                     ▼
┌─────────┐ ┌──────────┐       ┌─────────┐
│ Clicks  │ │ Key Press│       │ Change  │
│ Buttons │ │ (Enter)  │       │ Checkbox│
└────┬────┘ └─────┬────┘       └────┬────┘
     │            │                  │
     │            │                  │
     ▼            ▼                  ▼
  addTask()   handleEnter()    toggleTask()
  deleteTask() (event)          toggleGoalStep()
  openModal()                   (checkbox events)
  etc.
     │
     │
     ▼
┌──────────────────┐
│  Business Logic  │
│  - Mutate state  │
│  - Validate data │
│  - Calculate XP  │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   saveData()     │
│  (localStorage)  │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Render Updates  │
│  - renderTasks() │
│  - updateStats() │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   Side Effects   │
│  - playSound()   │
│  - celebrate()   │
│  - notifications │
└──────────────────┘
```

### Timer Event Loop

```
startTimer()
    │
    ├─ Set state.timer.isRunning = true
    ├─ Update UI (hide start, show pause)
    └─ Start interval
         │
         ▼
    setInterval(() => {
      updateTimer()
        │
        ├─ Decrement timeLeft
        │
        ├─ Check if <= 0?
        │     │
        │     ├─ YES → timerComplete()
        │     │          │
        │     │          ├─ Add XP
        │     │          ├─ Show notification
        │     │          ├─ Switch mode (focus ↔ break)
        │     │          └─ Reset UI
        │     │
        │     └─ NO → updateTimerDisplay()
        │
        └─ Continue loop
    }, 1000)
```

### Hourly Reminder System

```javascript
function setupHourlyReminder() {
  const now = new Date();
  const msToNextHour = (60 - now.getMinutes()) * 60 * 1000 
                     - now.getSeconds() * 1000;
  
  // Fire at next hour mark
  setTimeout(() => {
    showReminder();
    
    // Then every hour thereafter
    setInterval(showReminder, 60 * 60 * 1000);
  }, msToNextHour);
}
```

**Flow:**
1. Calculate milliseconds until next full hour
2. Set timeout to fire at that time
3. Show first reminder
4. Set up recurring interval (60 min)

---

## Timer Implementation

### Timer States

```
┌─────────────────────────────────────┐
│         Timer State Machine         │
└─────────────────────────────────────┘

    IDLE (initial)
      │
      │ startTimer()
      ▼
    RUNNING (focus mode)
      │
      ├─ pauseTimer() → PAUSED
      │                   │
      │                   │ startTimer()
      │                   └─────┐
      │                         │
      │◄────────────────────────┘
      │
      │ timeLeft reaches 0
      ▼
    COMPLETED (focus)
      │
      │ Auto-advance
      ▼
    RUNNING (break mode)
      │
      │ timeLeft reaches 0
      ▼
    COMPLETED (break)
      │
      │ Auto-reset
      ▼
    IDLE
```

### Timer Data Structure

```javascript
timer: {
  isRunning: false,    // Is actively counting down
  isPaused: false,     // Was running, now paused
  timeLeft: 1500,      // Seconds remaining
  focusTask: {         // Task being worked on
    id: 123,
    text: "Write docs"
  },
  mode: 'focus'        // 'focus' or 'break'
}
```

### Key Timer Functions

**startTimer()** (Line 1293)
```javascript
1. Get selected task from dropdown
2. Set timer.focusTask
3. Set timer.isRunning = true
4. Update button visibility (hide start, show pause)
5. Start interval: setInterval(updateTimer, 1000)
6. Play start sound
```

**updateTimer()** (Line 1335)
```javascript
1. Decrement timer.timeLeft by 1
2. If timeLeft <= 0:
   - Call timerComplete()
   - Exit
3. Else:
   - Call updateTimerDisplay()
```

**timerComplete()** (Line 1353)
```javascript
1. Clear interval
2. Check mode:
   
   IF focus mode:
   - Award 25 XP
   - Show celebration
   - Send notification "Focus Complete!"
   - Switch to break mode
   - Set timeLeft = breakDuration * 60
   - Update display text
   
   IF break mode:
   - Send notification "Break Over!"
   - Call resetTimer()
   
3. Set isRunning = false
4. Update UI (show start, hide pause)
5. Save state
```

**pauseTimer()** (Line 1312)
```javascript
1. Set isPaused = true
2. Set isRunning = false
3. Clear interval
4. Update buttons
```

**resetTimer()** (Line 1321)
```javascript
1. Clear interval
2. Set isRunning = false
3. Set isPaused = false
4. Reset timeLeft = focusDuration * 60
5. Set mode = 'focus'
6. Update buttons
7. Reset task display
8. Update display
```

### Display Format

Time is displayed in `MM:SS` format:

```javascript
function updateTimerDisplay() {
  const minutes = Math.floor(state.timer.timeLeft / 60);
  const seconds = state.timer.timeLeft % 60;
  
  document.getElementById('timerDisplay').textContent =
    `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
}
```

Example: `1500` seconds → `"25:00"`

---

## Notification System

### Notification Permission Flow

```
   App Initialization
          │
          ▼
requestNotificationPermission()
          │
    ┌─────┴─────┐
    │ Check if  │
    │ Supported │
    └─────┬─────┘
          │
    ┌─────▼──────┐
    │ Permission │
    │  = default?│
    └─────┬──────┘
          │
         YES
          │
          ▼
  Notification.requestPermission()
          │
    ┌─────┴─────┐
    │           │
   Granted   Denied
    │           │
    ▼           ▼
  Enable    Disable
  (save)    (save)
```

### Notification Types

**1. Hourly Reminder**
```javascript
new Notification('⏰ FocusFlow Reminder', {
  body: `Check your tasks and goals!\n\n"${quote}"`,
  icon: '🚀',
  requireInteraction: false
});
```

**2. Focus Session Complete**
```javascript
new Notification('Focus Session Complete! 🎉', {
  body: 'Great work! Time for a break.',
  icon: '⏱️'
});
```

**3. Break Complete**
```javascript
new Notification('Break Over! 💪', {
  body: 'Ready to focus again?',
  icon: '⏱️'
});
```

### Notification Timing

**Hourly Reminders:**
- Calculated to fire on the hour (00 minutes)
- First reminder: Calculated delay to next hour
- Subsequent: Every 3600000ms (60 minutes)

**Timer Notifications:**
- Fired when `timerComplete()` is called
- Only if `Notification.permission === 'granted'`

---

## UI Rendering Pipeline

### Rendering Strategy

FocusFlow uses **imperative DOM manipulation** with `innerHTML`:

```javascript
function renderTasks() {
  const container = document.getElementById('taskList');
  
  // Generate HTML string
  container.innerHTML = state.tasks.map(task => `
    <div class="task-item ${task.completed ? 'completed' : ''}">
      <!-- ... -->
    </div>
  `).join('');
}
```

**Pros:**
- Simple, easy to understand
- Works great for small datasets (<100 items)
- No virtual DOM overhead

**Cons:**
- Full re-render (not performant for large lists)
- Loses focus/scroll position
- No fine-grained reactivity

### Render Functions

| Function | Triggers | Updates |
|----------|----------|---------|
| `updateUI()` | Init, rollover | Calls all other renders |
| `renderTasks()` | Add, delete, toggle task | `#taskList` innerHTML |
| `renderGoals()` | Goal CRUD operations | `#goalsList` innerHTML |
| `renderTomorrowTasks()` | Tomorrow task changes | `#tomorrowTaskList` innerHTML |
| `updateStats()` | XP/streak changes | Stats values in header |
| `updateTimerDisplay()` | Timer tick | `#timerDisplay` text |
| `updateTimerTaskSelect()` | Task list changes | `#timerTaskSelect` options |
| `updateDateDisplay()` | Init only | `#dateDisplay` text |

### XSS Prevention

User input is escaped before rendering:

```javascript
function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;  // textContent auto-escapes
  return div.innerHTML;
}

// Usage
container.innerHTML = `
  <div>${escapeHtml(task.text)}</div>
`;
```

This prevents injection attacks if a user enters:
```
<script>alert('XSS')</script>
```

It will render as literal text, not execute.

---

## Performance Considerations

### Current Limitations

**localStorage Writes:**
- Every state change writes the entire state object
- For heavy usage (100+ tasks), this could cause performance issues
- **Mitigation:** Debounce `saveData()` calls

**Full List Re-renders:**
- `renderTasks()` regenerates entire task list HTML
- **Impact:** Low for <50 tasks, noticeable for >200 tasks
- **Mitigation:** Use fine-grained DOM updates or virtual DOM

**Timer Precision:**
- `setInterval(updateTimer, 1000)` is not guaranteed to be exact
- Browser throttles intervals in background tabs
- **Impact:** Timer may drift by a few seconds over 25 minutes
- **Mitigation:** Use `Date.now()` timestamps instead of decrement counter

### Optimization Opportunities

1. **Debounce localStorage writes**
   ```javascript
   const saveDataDebounced = debounce(saveData, 500);
   ```

2. **Virtual scrolling** for large task lists

3. **Lazy rendering** for goals (only render expanded goals)

4. **Service Worker** for offline support

5. **IndexedDB** for larger datasets

---

## Browser Compatibility

**Minimum Requirements:**
- ES6+ support (arrow functions, template literals, destructuring)
- localStorage API
- Canvas API
- Web Audio API (optional, graceful degradation)
- Notification API (optional, graceful degradation)

**Tested Browsers:**
- Chrome/Edge 90+
- Firefox 88+
- Safari 14+

**Not Supported:**
- Internet Explorer (ES6 features missing)

---

## Security Considerations

### XSS Protection
- All user input is escaped via `escapeHtml()`
- No use of `eval()` or `innerHTML` with raw user data

### Data Privacy
- All data stored locally in browser
- No external API calls
- No analytics or tracking
- No cookies

### localStorage Access
- Data accessible to any script on the same origin
- **Risk:** XSS could read all tasks/goals
- **Mitigation:** Keep browser updated, avoid suspicious extensions

---

## File Size Analysis

Total file size: **~85 KB** (unminified)

**Breakdown:**
- HTML: ~5 KB (structure + modals)
- CSS: ~15 KB (styling)
- JavaScript: ~65 KB (logic + quotes array)

**Minified:** Could reduce to ~50 KB
**Gzipped:** ~15 KB over network

---

## Extension Points

Areas where the architecture can be extended:

1. **Themes:** Add theme switcher by swapping CSS variables
2. **Cloud Sync:** Add backend API layer for multi-device sync
3. **Charts:** Add Chart.js for XP/streak visualization
4. **Categories:** Add task categories/tags
5. **Recurring Tasks:** Add RRULE-based recurring task system
6. **Time Tracking:** Track actual time spent per task
7. **Offline Support:** Add Service Worker
8. **Mobile App:** Wrap in Cordova/Capacitor

---

## Conclusion

FocusFlow demonstrates that a fully-featured productivity app can be built with zero dependencies and zero build process, making it extremely portable, maintainable, and easy to understand. The single-file architecture is ideal for personal productivity tools where simplicity and ownership matter more than scalability to thousands of users.
