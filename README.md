# My Tasks - Todo App

A modern task management application built with SwiftUI for iOS. This app helps you organize your daily tasks with an intuitive interface and powerful features.

## Features

- **Task Management**: Create, edit, and delete tasks with titles and descriptions
- **Priority Levels**: Assign priority (Low, Medium, High) to organize your tasks
- **Due Dates**: Set due dates for tasks with visual indicators for overdue items
- **Task Filtering**: Filter tasks by status (All, Active, Completed)
- **Statistics**: View overview of total, active, and completed tasks
- **Swipe Actions**: Swipe to delete or mark tasks as complete
- **Persistent Storage**: All tasks are automatically saved using UserDefaults

## Screenshots

![App Screenshot](screenshot.png)

The app displays:
- Statistics cards showing total, active, and completed tasks
- Segmented control for filtering tasks
- Task list with checkboxes, priorities, and due dates
- Clean, modern UI following iOS design guidelines

## Architecture

Built with SwiftUI using MVVM pattern. Data is persisted locally using UserDefaults. The project includes comprehensive unit and UI tests.

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Testing

The project includes comprehensive test coverage:

- **Unit Tests**: Test ViewModel logic and Task model
- **UI Tests**: Test user interactions and navigation

Run tests with `Cmd+U` in Xcode or use the test navigator.

## Development

This project was developed over 2 weeks starting January 1, 2026, with a focus on clean architecture, testability, and user experience.
