# FocusFlow Functional Specification

## Table of Contents
- [Product Overview](#product-overview)
- [User Personas](#user-personas)
- [Feature Catalog](#feature-catalog)
- [Data Models](#data-models)
- [Business Logic Rules](#business-logic-rules)
- [User Interface Specifications](#user-interface-specifications)
- [User Flows](#user-flows)
- [Edge Cases & Error Handling](#edge-cases--error-handling)
- [Accessibility](#accessibility)

---

## Product Overview

**FocusFlow** is a gamified daily productivity application designed to help users:
- Plan and track daily tasks
- Work toward long-term goals through small daily steps
- Stay focused using the Pomodoro technique
- Build consistency through streak tracking
- Stay motivated with XP rewards and motivational quotes

**Core Value Proposition:** Transform productivity into an engaging game where every completed task earns rewards, building motivation through visible progress.

---

## User Personas

### Primary: Sarah - The Busy Professional
- **Age:** 28-35
- **Occupation:** Software developer, product manager, consultant
- **Goals:** Manage multiple projects, stay organized, avoid burnout
- **Pain Points:** Context switching, losing track of tasks, lack of motivation
- **Usage:** Daily morning planning, Pomodoro sessions, evening review

### Secondary: Alex - The Student
- **Age:** 18-25
- **Occupation:** College/grad student
- **Goals:** Balance coursework, projects, personal development
- **Pain Points:** Procrastination, overwhelming workload, irregular schedule
- **Usage:** Study sessions with timer, break down large assignments

### Tertiary: Jordan - The Lifelong Learner
- **Age:** 30-50
- **Occupation:** Any, learning new skills in spare time
- **Goals:** Learn language, build side project, develop habits
- **Pain Points:** Slow progress, lack of structure, forgetting to practice
- **Usage:** Daily steps toward long-term goals, consistency tracking

---

## Feature Catalog

### 1. Daily Task Management

**Purpose:** Organize and track daily to-do items with priority levels.

**User Interaction:**
1. User types task in input field
2. User selects priority (Low/Medium/High)
3. User clicks "Add" or presses Enter
4. Task appears in list with priority badge
5. User clicks checkbox to mark complete
6. Task gets strike-through, XP awarded, celebration plays
7. User can delete tasks via trash icon

**Edge Cases:**
- Empty task: Ignored, no action taken
- Very long task text: No truncation, may wrap
- Special characters: Properly escaped to prevent XSS
- Completed tasks: Persist until "Clear Completed" clicked or daily rollover

**Business Rules:**
- Task XP reward: **10 XP** per completion
- Priority affects visual styling only (no XP multiplier)
- Incomplete tasks roll over to next day
- Completed tasks are discarded at midnight

---

### 2. Streak System

**Purpose:** Encourage daily engagement by tracking consecutive days of productivity.

**User Interaction:**
- Passive: User sees streak displayed in header
- Automatic: Streak increments when user completes ≥1 task and returns next day
- Celebration: Confetti + bonus XP every 7-day milestone

**Business Rules:**

**Streak Increment Conditions:**
```
IF:
  - lastOpenDate was exactly 1 day ago
  AND
  - completedTasksToday (yesterday's count) > 0
THEN:
  - streak += 1
  - IF streak > bestStreak: bestStreak = streak
  - IF streak % 7 === 0: Award 50 bonus XP
```

**Streak Reset Conditions:**
```
IF:
  - Days since lastOpenDate > 1
THEN:
  - streak = 0
```

**Special Cases:**
- Opening multiple times in same day: No change to streak
- Opening at midnight: Rollover logic handles transition
- No tasks yesterday: Streak resets even if consecutive days

**Display:**
- "🔥 N Day Streak" in header stats
- Red/orange fire emoji for visual reinforcement

---

### 3. XP & Leveling System

**Purpose:** Gamify productivity with experience points and level progression.

**XP Award Schedule:**

| Action | XP Reward |
|--------|-----------|
| Complete a task | +10 XP |
| Complete a goal step | +5 XP |
| Complete focus session (25 min) | +25 XP |
| 7-day streak milestone | +50 XP |

**Level Calculation:**
```javascript
level = Math.floor(Math.sqrt(xp / 10)) + 1
```

**Level Progression Table:**

| Level | XP Required | XP from Previous |
|-------|-------------|------------------|
| 1 | 0 | - |
| 2 | 10 | 10 |
| 3 | 40 | 30 |
| 4 | 90 | 50 |
| 5 | 160 | 70 |
| 10 | 810 | - |
| 20 | 3,610 | - |
| 50 | 24,010 | - |

**Business Rules:**
- XP is cumulative (never decreases)
- Level is display-only (no unlocks or gameplay changes)
- Level up has no special notification (passive progression)

**Edge Cases:**
- Unchecking a completed task: XP is NOT deducted (intentional)
- Importing data with high XP: Level recalculated correctly

---

### 4. Focus Timer (Pomodoro)

**Purpose:** Help users concentrate on a single task using timed work sessions.

**Default Settings:**
- Focus duration: **25 minutes**
- Break duration: **5 minutes**
- Both customizable via settings modal

**User Flow:**

```
1. User selects task from dropdown (optional)
2. User clicks "Start"
3. Timer counts down from 25:00
4. User can:
   - Pause (preserves time)
   - Reset (back to 25:00)
5. When timer reaches 0:00:
   - Award 25 XP
   - Show notification "Focus Complete!"
   - Show confetti celebration
   - Automatically switch to break timer (5:00)
6. Break timer counts down
7. When break reaches 0:00:
   - Notification "Break Over!"
   - Timer resets to idle state
```

**Visual States:**

| State | Button Visibility | Display Text |
|-------|-------------------|--------------|
| Idle | Start visible | "25:00" |
| Running | Pause visible | Counting down |
| Paused | Start visible | Frozen time |
| Break | Pause visible | Break countdown |

**Business Rules:**
- Timer runs in foreground only (browser `setInterval`)
- No automatic task completion (manual checkbox still required)
- Can start timer without selecting a task
- Task selection is informational only (displayed as "Focusing on: X")

**Edge Cases:**
- User closes tab: Timer state saved, but interval stops
- User returns hours later: Timer shows last saved state
- Background tab: Browser may throttle interval (timer may be inaccurate)
- Completing the task during timer: Timer continues (decoupled logic)

---

### 5. Goal Tracking

**Purpose:** Break down long-term goals into actionable steps.

**Data Model:**
```javascript
{
  id: timestamp,
  name: "Learn Spanish",
  steps: [
    { id: timestamp, text: "Learn 10 words", completed: false },
    { id: timestamp, text: "Practice 15min", completed: true }
  ],
  createdAt: ISO date string
}
```

**User Flow:**

```
1. User clicks "+ Add Goal"
2. Modal opens with fields:
   - Goal name (required)
   - First step (optional)
3. User enters "Learn Spanish" + "Learn 10 words"
4. User clicks "Save Goal"
5. System asks: "Add this step to today's tasks?"
   - Yes: Creates task with step text
   - No: Step stays in goal only
6. Goal appears in Goals panel
7. User clicks goal header to expand
8. Steps shown with checkboxes
9. User can:
   - Check off steps (+5 XP each)
   - Add new steps via input field
   - Push step to today's tasks (creates task)
   - Delete entire goal
```

**Business Rules:**
- Goals have no completion state (only steps do)
- Progress bar: `completed steps / total steps`
- Checking a step: Awards 5 XP
- "Push to today": Creates duplicate as task (step remains in goal)
- Goals persist across days (no rollover)

**Edge Cases:**
- Goal with no steps: 0% progress shown
- Deleting last step: Progress becomes 0%
- Very long goal name: May wrap in UI
- Deleting goal: Confirmation dialog shown

---

### 6. Plan Tomorrow

**Purpose:** Reduce morning friction by preparing next day's tasks in advance.

**User Flow:**

```
1. User clicks "Plan Tomorrow" (or evening banner)
2. Modal opens showing tomorrow's task list
3. User adds tasks (same input as regular tasks)
4. Tasks stored in separate `tomorrowTasks` array
5. User closes modal (tasks saved)
6. Next day at app open:
   - Rollover logic moves `tomorrowTasks` → `tasks`
   - `tomorrowTasks` array cleared
   - Tasks appear in Today's Tasks automatically
```

**Evening Banner:**
- Shown between 6:00 PM - 10:59 PM local time
- Animated pulse effect
- Call-to-action button to open modal
- Hidden rest of day

**Business Rules:**
- Tomorrow tasks have no priority field (default to "medium")
- Tomorrow tasks have no completion state
- If user doesn't open app next day, tasks remain in `tomorrowTasks`
- When rolled over, tasks behave exactly like manually added tasks

**Edge Cases:**
- User plans tomorrow, then adds more later same evening: Appends to list
- User doesn't open app for 3 days: Tomorrow tasks still waiting to roll over
- User manually deletes tomorrow task: Removed immediately

---

### 7. Daily Rollover

**Purpose:** Automatically manage task lifecycle across days.

**Trigger:** App initialization (`init()` → `checkAndRolloverTasks()`)

**Rollover Logic:**

```javascript
const today = new Date().toDateString(); // "Tue Jul 09 2024"

if (state.lastOpenDate !== today) {
  // === NEW DAY DETECTED ===
  
  // 1. STREAK CALCULATION
  const lastDate = new Date(state.lastOpenDate);
  const daysDiff = Math.floor((todayDate - lastDate) / (1000*60*60*24));
  
  if (daysDiff === 1 && state.completedTasksToday > 0) {
    // Consecutive day with work done
    state.streak++;
    if (state.streak > state.bestStreak) {
      state.bestStreak = state.streak;
    }
    if (state.streak % 7 === 0) {
      // Weekly milestone
      state.xp += 50;
      celebrateStreak();
    }
  } else if (daysDiff > 1) {
    // Missed a day
    state.streak = 0;
  }
  
  // 2. TASK ROLLOVER
  // Keep incomplete, discard completed
  state.tasks = state.tasks.filter(t => !t.completed);
  
  // 3. TOMORROW TASKS → TODAY
  if (state.tomorrowTasks && state.tomorrowTasks.length > 0) {
    state.tasks = [...state.tasks, ...state.tomorrowTasks];
    state.tomorrowTasks = [];
  }
  
  // 4. RESET COUNTERS
  state.lastOpenDate = today;
  state.completedTasksToday = 0;
  
  // 5. PERSIST
  saveData();
}
```

**Visual Impact:**
- User sees yesterday's incomplete tasks still present
- User sees planned tasks now available
- Streak may have changed (up or reset)
- Task completion counter reset to 0/N

**Edge Cases:**
- Opening at exactly midnight: Rollover happens immediately
- Opening multiple times same day: No rollover after first
- First-time user (no lastOpenDate): Sets today, no rollover
- Time zone changes: Uses local time string comparison (may cause issues if traveling)

---

### 8. Motivational Quotes

**Purpose:** Provide encouragement and keep users motivated.

**Implementation:**
- 50 curated quotes stored in `QUOTES` array (lines 777-828)
- Random quote shown on page load
- New random quote shown after task completion (celebration)
- Quotes included in hourly reminder notifications

**Display Location:**
- Quote section below header (italic text, accent border)

**Sample Quotes:**
- "Your only limit is you."
- "Dream big. Start small. Act now."
- "Small steps every day lead to big changes."

---

### 9. Celebrations & Feedback

**Purpose:** Provide immediate positive reinforcement for achievements.

**Celebration Triggers:**

| Event | Visual | Audio | XP |
|-------|--------|-------|-----|
| Task completed | Confetti | C-E-G chord | +10 |
| Goal step completed | None | C-E chord | +5 |
| Focus session done | Confetti | C-E-G chord | +25 |
| Streak milestone | Confetti + Alert | None | +50 |
| Task added | None | Single A note | 0 |
| Timer started | None | G note | 0 |

**Confetti Animation:**
- Canvas-based particle system
- 50 colored particles
- Fall with tilt/rotation physics
- 5 brand colors used
- Self-clearing after particles leave canvas

**Sound System:**
- Web Audio API oscillator
- Simple beep tones
- Volume: 0.3 (30%)
- No user control (always on if browser allows)

---

### 10. Data Export/Import

**Purpose:** Allow users to backup and restore their data.

**Export:**
1. User clicks "Export Data"
2. System serializes entire `state` object to JSON
3. Downloads as `focusflow-backup-YYYY-MM-DD.json`
4. File contains all tasks, goals, settings, XP, streaks

**Import:**
1. User clicks "Import Data"
2. File picker opens (accepts `.json`)
3. System reads file
4. Validates JSON parsing
5. Confirmation dialog: "This will replace all your current data. Continue?"
6. If yes: Replaces `state` with imported data
7. Calls `updateUI()` to refresh display

**Edge Cases:**
- Invalid JSON: Alert "Invalid backup file!"
- Missing fields: May cause errors (no validation)
- User cancels file picker: No action taken
- Imported data has different schema version: No migration logic (may break)

---

### 11. Hourly Reminders

**Purpose:** Keep FocusFlow top-of-mind throughout the day.

**Setup:**
```javascript
// Calculate time until next hour
const now = new Date();
const msToNextHour = (60 - now.getMinutes()) * 60 * 1000 
                   - now.getSeconds() * 1000;

// First reminder at next hour
setTimeout(() => {
  showReminder();
  // Recurring every hour
  setInterval(showReminder, 3600000);
}, msToNextHour);
```

**Reminder Content:**
- Title: "⏰ FocusFlow Reminder"
- Body: "Check your tasks and goals!\n\n"{random quote}""
- Icon: 🚀
- Not persistent (auto-dismisses)

**Requirements:**
- Notification permission must be granted
- App must be open in browser (reminders stop if tab closed)

**User Control:**
- "Test Reminder" button in Quick Actions
- No disable option (close tab to stop)

---

## Data Models

### Task

```typescript
interface Task {
  id: number;              // Unix timestamp (Date.now())
  text: string;            // User-entered task description
  priority: 'low' | 'medium' | 'high';
  completed: boolean;
  createdAt: string;       // ISO 8601 date string
}
```

**Validation:**
- `text`: Must be non-empty after trim
- `priority`: Defaults to 'medium'
- `completed`: Defaults to false
- `createdAt`: Auto-generated

**Constraints:**
- `id` must be unique (timestamp collision unlikely)
- `text` max length: None enforced (localStorage limit)

---

### Goal

```typescript
interface Goal {
  id: number;              // Unix timestamp
  name: string;            // Goal title
  steps: GoalStep[];       // Array of steps
  createdAt: string;       // ISO 8601 date
}

interface GoalStep {
  id: number;              // Unix timestamp
  text: string;            // Step description
  completed: boolean;
}
```

**Validation:**
- `name`: Must be non-empty
- `steps`: Can be empty array
- Step `text`: Must be non-empty when adding

**Constraints:**
- No deadline or target date
- No categories or tags
- No ordering/prioritization of steps

---

### Settings

```typescript
interface Settings {
  focusDuration: number;      // Minutes (1-60)
  breakDuration: number;      // Minutes (1-30)
  notificationsEnabled: boolean;
}
```

**Validation:**
- `focusDuration`: Integer, min 1, max 60
- `breakDuration`: Integer, min 1, max 30

**Defaults:**
- Focus: 25 minutes
- Break: 5 minutes

---

### Timer State

```typescript
interface TimerState {
  isRunning: boolean;
  isPaused: boolean;
  timeLeft: number;          // Seconds remaining
  focusTask: Task | null;    // Reference to selected task
  mode: 'focus' | 'break';
}
```

**State Transitions:**
- Only one of `isRunning` or `isPaused` should be true
- `timeLeft` counted down by 1 every second
- `mode` switches automatically at completion

---

## Business Logic Rules

### XP Calculation

```javascript
// Task completion
xp += 10

// Goal step completion
xp += 5

// Focus session completion
xp += 25

// 7-day streak milestone
if (streak % 7 === 0) {
  xp += 50
}
```

**XP is never deducted.**

---

### Level Calculation

```javascript
level = Math.floor(Math.sqrt(xp / 10)) + 1
```

**Examples:**
- 0 XP → Level 1
- 10 XP → Level 2
- 40 XP → Level 3
- 90 XP → Level 4
- 810 XP → Level 10

**Progression is exponential** (increasingly harder to level up).

---

### Task Rollover Rules

**Keep:**
- Tasks where `completed === false`

**Discard:**
- Tasks where `completed === true`

**Add:**
- All tasks from `tomorrowTasks` array

**Result:**
```javascript
state.tasks = [
  ...state.tasks.filter(t => !t.completed),
  ...state.tomorrowTasks
];
state.tomorrowTasks = [];
```

---

### Streak Rules

**Increment:**
```javascript
IF (
  daysSinceLastOpen === 1 
  AND 
  completedTasksToday > 0
) {
  streak++
}
```

**Reset:**
```javascript
IF (daysSinceLastOpen > 1) {
  streak = 0
}
```

**Maintain:**
```javascript
IF (daysSinceLastOpen === 0) {
  // Same day, no change
}
```

**Edge Case: Skip a Day With Tasks Pending**
- Last open: Monday (completed 3 tasks)
- Open again: Wednesday
- Result: Streak resets to 0 (Tuesday was missed)

---

### Goal Progress Calculation

```javascript
const completed = goal.steps.filter(s => s.completed).length;
const total = goal.steps.length;
const progress = total > 0 
  ? (completed / total) * 100 
  : 0;
```

**Progress bar width:**
```css
width: ${progress}%
```

---

## User Interface Specifications

### Color Palette

```css
--bg-primary: #1a1a2e       (Dark blue-black)
--bg-secondary: #16213e     (Lighter panel background)
--bg-card: #0f3460          (Card/input background)
--accent: #e94560           (Pink/red accent)
--accent-light: #ff6b8a     (Hover states)
--text-primary: #eee        (Light gray text)
--text-secondary: #aaa      (Dimmer text)
--success: #00d4aa          (Teal/green)
--warning: #ffd93d          (Yellow/gold)
--gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%)
```

### Typography

```css
font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif
line-height: 1.6

Headers:
  h1: 2.5em (40px)
  h2: 1.8em (28.8px)

Body: 1em (16px)
Small text: 0.9em
Timer: 4em (huge display)
```

### Layout Structure

**Responsive Grid:**
- Desktop (>1200px): 2-column grid for panels
- Tablet/Mobile (<1200px): Single column stack

**Panel Dimensions:**
- Max container width: 1400px
- Panel padding: 25px
- Panel border-radius: 20px
- Gap between panels: 30px

### Component Dimensions

**Buttons:**
- Padding: 12px 24px
- Border-radius: 10px
- Small buttons: 8px 16px

**Inputs:**
- Padding: 12px
- Border-radius: 10px
- Border: 2px solid transparent
- Focus border: 2px solid accent

**Cards:**
- Task item: 15px padding, 12px border-radius
- Goal item: 20px padding, 12px border-radius
- Stat card: 15px 25px padding, 15px border-radius

---

### Stat Cards (Header)

**Layout:**
```
┌────────────────────────────────────────────────┐
│  🚀 FocusFlow          Tue July 9, 2024       │
│                                                │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐       │
│  │ 🔥       │ │ ⭐       │ │ 📊       │       │
│  │  5       │ │  450     │ │  4       │       │
│  │ Day      │ │ Total XP │ │ Level    │       │
│  │ Streak   │ │          │ │          │       │
│  └──────────┘ └──────────┘ └──────────┘       │
│                                                │
│  ┌──────────┐                                  │
│  │ ✅       │                                  │
│  │  3/5     │                                  │
│  │ Tasks    │                                  │
│  │ Today    │                                  │
│  └──────────┘                                  │
└────────────────────────────────────────────────┘
```

**Data Shown:**
1. Streak (fire emoji)
2. Total XP (star emoji)
3. Current Level (chart emoji)
4. Today's task completion (checkmark emoji)

---

### Task Item

```
┌────────────────────────────────────────────┐
│ ☑  Write documentation  [HIGH]  🗑️        │
└────────────────────────────────────────────┘
  │   │                     │       │
  │   │                     │       └── Delete button
  │   │                     └────────── Priority badge
  │   └───────────────────────────────── Task text
  └───────────────────────────────────── Checkbox
```

**States:**
- Uncompleted: Full opacity, no strike-through
- Completed: 60% opacity, strike-through text
- Hover: Translate 5px right, shadow

**Priority Badges:**
- High: Pink/red background (#e94560)
- Medium: Yellow background (#ffd93d), dark text
- Low: Dark background (#16213e)

---

### Goal Item

**Collapsed View:**
```
┌─────────────────────────────────────────┐
│ Learn Spanish                      🗑️  │
│ ████████░░░░░░░░░░░░░░  (40%)           │
│ 2 / 5 steps completed                   │
└─────────────────────────────────────────┘
```

**Expanded View:**
```
┌─────────────────────────────────────────┐
│ Learn Spanish                      🗑️  │
│ ████████░░░░░░░░░░░░░░  (40%)           │
│ 2 / 5 steps completed                   │
│ ┌─────────────────────────────────────┐ │
│ │ ☑ Learn 10 words       [→ Today]   │ │
│ │ ☐ Practice 15min       [→ Today]   │ │
│ │ ☑ Watch tutorial       [→ Today]   │ │
│ │                                     │ │
│ │ [Add step input field]              │ │
│ │ [Add Step]                          │ │
│ └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

---

### Timer Display

```
┌─────────────────────────────────────────┐
│      ⏱️ Focus Timer            ⚙️       │
│                                         │
│  Focusing on: Write documentation       │
│                                         │
│           25:00                         │
│         (gradient)                      │
│                                         │
│    [Start]  [Pause]  [Reset]            │
│                                         │
│  Focus on: [Select task ▼]             │
└─────────────────────────────────────────┘
```

**Timer States:**
- Idle: "25:00" in gradient text
- Running: Countdown with Pause button visible
- Break: "Break time! Relax and recharge 🌟"

---

### Modals

**Structure:**
```
Full-screen overlay (rgba(0,0,0,0.8))
  │
  └── Modal content (centered)
       ├── Header (title + close button)
       ├── Body (form fields / content)
       └── Footer (action buttons)
```

**Dimensions:**
- Max width: 600px
- Width: 90% (mobile friendly)
- Max height: 80vh (scrollable)
- Padding: 40px
- Border-radius: 20px

**Close Methods:**
- Click X button
- Click outside modal (not implemented)
- Press Escape (not implemented)

---

## User Flows

### Flow 1: Morning Planning

```
User opens FocusFlow
  │
  ▼
Rollover happens
  - Yesterday's incomplete tasks shown
  - Planned tasks added
  - Streak updated
  │
  ▼
User reviews tasks
  │
  ▼
User adds new tasks
  - Type task
  - Select priority
  - Press Enter
  │
  ▼
Tasks prioritized in mental model
(High priority likely worked first)
  │
  ▼
User starts first task
```

---

### Flow 2: Focus Session

```
User selects task from timer dropdown
  │
  ▼
User clicks Start
  │
  ▼
Timer counts down 25:00
  │
  ├── User works on task
  │
  └── Timer reaches 0:00
      │
      ▼
  Notification: "Focus complete!"
  Confetti animation
  +25 XP awarded
      │
      ▼
  Auto-switch to break (5:00)
      │
      ▼
  User takes break
      │
      ▼
  Break ends
      │
      ▼
  Notification: "Break over!"
  Timer resets
      │
      ▼
  User manually checks off task
  +10 XP awarded
  Confetti again
```

---

### Flow 3: Setting a Long-Term Goal

```
User clicks "+ Add Goal"
  │
  ▼
Modal opens
  │
  ▼
User enters:
  - Goal: "Learn Spanish"
  - First step: "Learn 10 words"
  │
  ▼
User clicks "Save Goal"
  │
  ▼
Prompt: "Add this step to today's tasks?"
  │
  ├── Yes → Task created
  │
  └── No → Step stays in goal only
  │
  ▼
Goal appears in Goals panel
  │
  ▼
Over time:
  - User adds more steps
  - User checks off steps (+5 XP each)
  - User pushes steps to daily tasks
  - Progress bar fills up
  │
  ▼
All steps complete (100% progress)
User feels accomplished!
(No system "goal complete" event)
```

---

### Flow 4: Evening Planning

```
6:00 PM - Evening banner appears
  │
  ▼
User clicks "Plan Tomorrow"
  │
  ▼
Modal opens
  │
  ▼
User brainstorms tomorrow's tasks
  │
  ▼
User adds tasks to list
  - "Morning standup"
  - "Code review session"
  - "Gym"
  │
  ▼
User closes modal
  │
  ▼
Tasks saved to tomorrowTasks[]
  │
  ▼
Next morning:
  │
  ▼
User opens FocusFlow
  │
  ▼
Rollover moves planned tasks to today
  │
  ▼
User sees tasks ready to go!
(Reduced morning decision fatigue)
```

---

### Flow 5: Data Backup

```
User clicks "Export Data"
  │
  ▼
Browser downloads JSON file
  - focusflow-backup-2024-07-09.json
  │
  ▼
User stores file safely
(Google Drive, Dropbox, etc.)
  │
  ▼
[Time passes]
  │
  ▼
User gets new computer / clears browser data
  │
  ▼
User opens FocusFlow (fresh state)
  │
  ▼
User clicks "Import Data"
  │
  ▼
User selects backup file
  │
  ▼
Confirmation: "Replace all data?"
  │
  ▼
User confirms
  │
  ▼
All tasks, goals, XP, streaks restored!
```

---

## Edge Cases & Error Handling

### Task Management

**Empty Task Input:**
- **Behavior:** Ignored, function returns early
- **User Feedback:** None (should show error message)

**Very Long Task Text:**
- **Behavior:** Renders fully, may wrap to multiple lines
- **UI Impact:** Task item grows vertically

**XSS Attempt:**
- **Input:** `<script>alert('XSS')</script>`
- **Behavior:** Escaped to `&lt;script&gt;...`
- **Protection:** `escapeHtml()` function

**Checkbox Spam:**
- **Behavior:** Each click toggles state and awards/removes XP
- **Issue:** Unchecking doesn't deduct XP (intentional)

---

### Streak System

**Open at Midnight:**
- **Scenario:** User opens at 11:59 PM, then 12:01 AM
- **Behavior:** Second open triggers rollover
- **Streak:** Increments if tasks completed yesterday

**Time Zone Travel:**
- **Scenario:** User travels across time zones
- **Behavior:** Uses local time string comparison
- **Issue:** May cause premature rollover or streak reset

**No Tasks Yesterday:**
- **Scenario:** User opened app but didn't complete anything
- **Behavior:** Streak resets to 0
- **Rationale:** Streak requires productivity, not just opening app

---

### Timer

**Browser Tab Backgrounded:**
- **Behavior:** `setInterval` may be throttled
- **Impact:** Timer may run slow (e.g., 25min takes 27min)
- **Mitigation:** None (limitation of web platform)

**User Closes Tab Mid-Session:**
- **Behavior:** Timer state saved, interval stops
- **User Returns:** Timer shows last saved state (paused essentially)

**Timer at 0:00 Exactly:**
- **Behavior:** `timerComplete()` fires
- **Clear Interval:** Yes
- **Edge Case:** If multiple tabs open, each has own timer

---

### Goals

**Goal With No Steps:**
- **Behavior:** Shows 0/0 steps, 0% progress
- **Display:** Empty progress bar

**Deleting Last Step:**
- **Behavior:** Goal remains, 0% progress

**Pushing Same Step Multiple Times:**
- **Behavior:** Creates duplicate tasks (intentional)
- **Use Case:** User wants to do step daily

---

### localStorage

**Quota Exceeded:**
- **Limit:** ~5-10MB depending on browser
- **Behavior:** `localStorage.setItem()` throws `QuotaExceededError`
- **Handling:** None (will crash silently)
- **Mitigation:** Keep data minimal, add try-catch

**Corrupt Data:**
- **Scenario:** User manually edits localStorage
- **Behavior:** `JSON.parse()` may fail
- **Handling:** None (app will break)
- **Mitigation:** Add try-catch in `loadData()`

**Private Browsing:**
- **Behavior:** localStorage may be disabled
- **Impact:** App unusable (data doesn't persist)
- **Detection:** None currently implemented

---

### Notifications

**Permission Denied:**
- **Behavior:** Notifications don't show (silent failure)
- **User Feedback:** None
- **Impact:** Hourly reminders and timer alerts don't work

**Browser Doesn't Support Notifications:**
- **Behavior:** Permission check skipped
- **Impact:** No notifications

**Multiple Tabs Open:**
- **Behavior:** Each tab sends its own notifications
- **Impact:** Duplicate notifications

---

## Accessibility

### Current State

**Keyboard Navigation:**
- **Enter key:** Submits tasks in input fields
- **Tab navigation:** Works for buttons/inputs (native browser)
- **No custom keyboard shortcuts**

**Screen Readers:**
- **Semantic HTML:** Minimal (heavy use of `<div>`)
- **ARIA labels:** None
- **Alt text:** N/A (no images, only emoji)
- **Status:** Poor accessibility

**Color Contrast:**
- **Text on background:** Good contrast (light text on dark bg)
- **Priority badges:** Medium text on yellow may fail WCAG AA

**Focus Indicators:**
- **Inputs:** Custom focus ring (accent color)
- **Buttons:** Native browser focus (should be enhanced)

---

### Recommended Improvements

1. **Add ARIA Labels:**
   ```html
   <button aria-label="Add new task" onclick="addTask()">Add</button>
   <input aria-label="New task description" id="newTaskInput">
   ```

2. **Semantic HTML:**
   - Use `<button>` instead of clickable `<div>`
   - Use `<form>` for task input sections
   - Use `<article>` for task items

3. **Keyboard Shortcuts:**
   - `Ctrl+N`: New task
   - `Ctrl+G`: New goal
   - `Ctrl+Space`: Start/pause timer
   - `Escape`: Close modal

4. **Focus Management:**
   - When modal opens, focus first input
   - When modal closes, return focus to trigger element

5. **Screen Reader Announcements:**
   - Announce XP gains
   - Announce task completions
   - Announce timer state changes

6. **Color Blind Considerations:**
   - Add icons to priority levels (not just color)
   - Add texture/pattern to progress bars

---

## Internationalization (i18n)

**Current State:** English only, hard-coded strings.

**i18n Readiness:**
- All user-facing text is in JavaScript (easy to extract)
- Dates use `toLocaleDateString()` (locale-aware)
- No server-side rendering (purely client-side)

**Future i18n Support:**
- Extract strings to language JSON files
- Use i18n library (e.g., i18next)
- Support RTL languages (CSS changes needed)

---

## Performance Characteristics

**Initial Load:**
- Single HTML file: ~85 KB
- Parse + execute: <100ms on modern hardware
- Time to interactive: <200ms

**Render Performance:**
- Small datasets (<50 tasks): Instant
- Large datasets (>200 tasks): Noticeable lag on full re-render
- Timer updates: Smooth (60fps capable)

**Memory Usage:**
- Baseline: ~5-10 MB
- Per task: ~1 KB
- Confetti animation: Spike to ~20 MB during animation

**Battery Impact:**
- Timer running: Minimal (1 interval per second)
- Hourly reminders: Negligible
- Animations: Brief spikes during confetti

---

## Future Feature Ideas

1. **Task Categories/Tags:** Group tasks by project/context
2. **Recurring Tasks:** Daily, weekly, custom schedules
3. **Time Tracking:** Log actual time spent per task
4. **Charts & Analytics:** Visualize productivity trends
5. **Cloud Sync:** Multi-device support
6. **Themes:** Light mode, custom color schemes
7. **Subtasks:** Break tasks into smaller pieces
8. **Collaboration:** Share goals with accountability partners
9. **Calendar Integration:** Sync with Google Calendar
10. **Mobile App:** Native iOS/Android version

---

## Conclusion

FocusFlow successfully combines task management, goal tracking, and gamification into a cohesive productivity experience. The feature set is intentionally focused on core productivity workflows while maintaining simplicity and ease of use. The single-file architecture ensures the app remains accessible, portable, and maintainable.
