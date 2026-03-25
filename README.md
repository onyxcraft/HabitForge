# HabitForge

A powerful habit tracking app with streak gamification for iOS 17+.

## Features

- **Create Custom Habits**: Design habits with custom names, SF Symbol icons, colors, and frequency (daily/weekly/custom days)
- **One-Tap Completion**: Mark habits complete with satisfying animations
- **Streak Tracking**: Build and maintain streaks with fire animations for milestones (7, 30, 100+ days)
- **Calendar Heatmap**: GitHub-style visualization showing your habit completion history
- **Comprehensive Stats**: Track completion rate, longest streak, total completions, and more
- **Home Screen Widgets**:
  - Habit Checklist (Small/Medium): View and track daily habits
  - Streak Display (Small): Show your top current streak
- **Smart Reminders**: Customizable notifications for each habit
- **Habit Groups**: Organize habits into categories
- **Dark Mode**: Full support for light and dark appearance
- **iPad Support**: Optimized layouts for iPad

## Technical Details

- **Platform**: iOS 17.0+, iPadOS 17.0+
- **Architecture**: SwiftUI + MVVM
- **Persistence**: SwiftData
- **Widgets**: WidgetKit
- **Notifications**: UserNotifications framework
- **No External Dependencies**: Pure Swift implementation

## Bundle Information

- **Bundle ID**: com.lopodragon.habitforge
- **Price**: $3.99 USD (one-time purchase)

## Project Structure

```
HabitForge/
├── Models/
│   ├── Habit.swift
│   ├── HabitCompletion.swift
│   └── HabitGroup.swift
├── ViewModels/
│   └── HabitViewModel.swift
├── Views/
│   ├── HabitListView.swift
│   ├── HabitDetailView.swift
│   ├── HabitFormView.swift
│   ├── HabitRowView.swift
│   ├── StatsView.swift
│   └── HabitGroupView.swift
├── Components/
│   ├── CalendarHeatmapView.swift
│   ├── CompletionAnimationView.swift
│   ├── StreakFireView.swift
│   └── SFSymbolPicker.swift
├── Extensions/
│   ├── Date+Extension.swift
│   └── ColorPicker+Extension.swift
├── Managers/
│   └── NotificationManager.swift
└── Assets.xcassets

HabitForgeWidget/
├── HabitForgeWidgetBundle.swift
├── HabitChecklistWidget.swift
├── StreakWidget.swift
└── Assets.xcassets
```

## Building

1. Open `HabitForge.xcodeproj` in Xcode 15+
2. Select your development team in project settings
3. Build and run on iOS 17+ device or simulator

## Requirements

- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

## License

MIT License - See LICENSE file for details

## Author

Created with Claude Code
