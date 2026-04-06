# 🕌 Salah Tracker App

Salah Tracker App is an Android app designed to help Muslims stay consistent with
their daily prayers. It allows users to easily log each Salah and track their
performance over time.

---

## 🎯 App Goal

Salah Tracker App helps users:

- Log their 5 daily prayers
- Track consistency over time
- Visualize progress through simple statistics

The focus is on **clarity, calm design, and daily habit building**.

---

## ✨ Core Features

### 📱 1. Daily Salah Tracking

Track the 5 daily prayers:

- Fajr
- Dhuhr
- Asr
- Maghrib
- Isha

Each prayer supports **4 statuses**:

- ✅ Prayed on time
- 🕰️ Qaza (late)
- ❌ Missed

Rules:

- Only **one status per prayer per day**
- Works fully **offline** and **online**

---

### 📊 2. Statistics Screen

Infographic-style dashboard:

Includes:

- Daily completion %
- Weekly summary
- Monthly summary
- Streak counter

Visuals:

- Progress bars
- Pie chart (status distribution)
- Clean card layout

---

### 🔄 3. Navigation

Bottom tabs:

- Home
- Statistics

---

### 🔔 4. Extra Features

- Prayer reminders (local notifications)
- Settings screen (toggle reminders)

---

## 🎨 UI / UX Design

### 🌿 Theme Style

- Minimal, calm, modern
- Islamic-inspired palette
- Smooth spacing & rounded UI

---

### 🔤 Typography

- Font: **DM Sans**
- Clean, readable, modern

---

### 💡 UI Principles

- Spacious layout
- Rounded cards (12–16px)
- Soft animations
- No bright/neon colors

---

### 📊 Calculations

#### Daily Completion

```
(On Time + Mosque) / 5 * 100
```

#### Weekly / Monthly

- Aggregate by date

#### Streak

- Count consecutive days with no "Missed"

---

## ⚙️ Tech Stack

### 📱 Frontend

- Flutter

---

### 🗄️ Backend

- Supabase

---

### 🧩 Core Technologies

- Dart → main language for Flutter app
- Flutter SDK → build UI and app structure
- Material 3 → modern UI components & theming

---

### 🧠 State Management

- Riverpod → scalable and clean state management

---

### 💾 Local Storage (Offline First)

- sqflite → structured local database (like Room)
- Hive → fast lightweight storage (optional/simple use)

---

### 📊 Charts & Visualization

- fl_chart → pie charts, graphs, statistics UI

---

### 📅 Date & Time

- intl → date formatting and localization

---

### 🔔 Notifications

- flutter_local_notifications → prayer reminders

---

### 🧭 Navigation

- go_router → app routing and navigation

---

## 📦 Key Components

### Screens

- Tracker Screen (daily input)
- Stats Screen (analytics)
- Settings Screen (notifications)

---

### Database

- SQLite schema for prayers
- CRUD operations

---

### State

- Global store for UI + data sync

---

### Utilities

- Date helpers
- Calculation logic

---

## 🚀 Development Goals

- Clean, production-ready code
- Fast and responsive UI
- Offline-first reliability
- Online reliability
- Simple user experience
- Cloud sync (Supabase

---

## 🧩 Future Improvements

- User accounts
- Backup & restore
- Advanced analytics
- Home screen widgets

---

## 📌 Notes for AI / Developers

- Keep logic simple
- Avoid over-engineering
- Focus on UX clarity
- Maintain consistent design
- Optimize for performance

---

## 🤲 Purpose

This app helps users build **consistency, discipline, and awareness** in daily
Salah through simple tracking and reflection.

---

**End of README**
