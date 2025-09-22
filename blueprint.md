# Expense Share App Blueprint

## Overview

This document outlines the functional and UI details of the Expense Share application. The app is built with Flutter and uses the `provider` package for state management.

## Functional Details

### State Management

- **`AppState` class:** This class extends `ChangeNotifier` and serves as the single source of truth for the application's state. It manages:
  - A list of `ExpenseType` objects.
  - A list of `Member` objects.
  - A list of `Expense` objects.
  - The current `ThemeMode`.

- **`ChangeNotifierProvider`:** The root of the application is wrapped in a `ChangeNotifierProvider` to make the `AppState` available to all widgets in the widget tree.

### Core Features

- **Expense Tracking:**
  - Add new expenses with details like amount, payer, expense type, date, and optional notes.
  - Delete expenses.
  - View a list of all expenses.

- **Member Management:**
  - Add new members to the group.
  - Delete members from the group.
  - View a list of all members and their total expenses.

- **Expense Type Management:**
  - Create custom expense types (e.g., "Food," "Travel," "Rent").
  - Delete expense types.

- **Payment Tracking:**
  - Mark a member's expenses as paid or unpaid using a checkbox.

- **Theme Customization:**
  - Toggle between light and dark themes.
  - Set the theme to follow the system's theme setting.

## UI Details

### `MyApp` Widget

- The main application widget.
- Configures the light and dark themes using `ThemeData`.
- Uses `ColorScheme.fromSeed` with `Colors.deepPurple` as the seed color.
- Sets up the `MaterialApp` with the title "Expense Share."
- Uses a `Consumer<AppState>` to listen for theme changes and rebuild the UI accordingly.

### `HomeScreen` Widget

- The main screen of the application.
- **AppBar:**
  - Title: "Expense Share"
  - Actions:
    - An `IconButton` to toggle between light and dark modes.
    - An `IconButton` to set the theme to the system's default.
- **Body:**
  - A `Column` containing:
    - An `ElevatedButton` to navigate to the "Manage Expense Types" screen.
    - An `ElevatedButton` to navigate to the "Manage Members" screen.
    - An `ElevatedButton` to navigate to the "Add Expense" screen.
    - A `Text` widget with the label "Member Expenses:".
    - An `Expanded` `ListView.builder` that displays a list of members. Each list item is a `ListTile` showing:
      - The member's name and their total expense amount.
      - A `Checkbox` to mark the member's expenses as paid.

### `AddExpenseScreen` Widget

- A screen for adding a new expense.
- **AppBar:**
  - Title: "Add Expense"
- **Body:**
  - A `Padding` widget containing a `Column` with the following form fields:
    - A `TextFormField` for the expense amount (numeric keyboard).
    - A `DropdownButtonFormField` to select the payer from the list of members.
    - A `DropdownButtonFormField` to select the expense type.
    - A `TextFormField` for optional notes (with a 100-character limit).
    - An `ElevatedButton` labeled "Add" to submit the form. The button is disabled if the payer or expense type is not selected.

### Other Screens (Inferred)

- **`ExpenseTypeScreen`:** A screen to manage expense types. It likely contains a list of existing expense types and a way to add and delete them.
- **`MemberScreen`:** A screen to manage members. It likely contains a list of existing members and a way to add and delete them.
