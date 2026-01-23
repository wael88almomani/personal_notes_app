# Personal Notes App

A local-first Flutter notes application for quickly creating, editing, and organizing personal notes. Built as an academic/portfolio project to demonstrate mobile UI design, state management, and offline persistence with SQLite.

---

## Features

- Create, edit, and delete text notes.
- Local SQLite storage (works offline).
- Sort/refresh on the home screen with Material UI cards.
- Friendly date formatting for created/updated timestamps.
- Simple navigation between home and add/edit flows.

---

## Project Structure

```
lib/
├── main.dart               # App entry point; wires Flutter bindings, theme, and initial route
├── app.dart                # App widget tree and navigation setup
├── models/
│   └── note_model.dart     # Note data model with to/from map helpers
├── database/
│   └── database_helper.dart# SQLite initialization and CRUD helpers
├── screens/
│   ├── home_screen.dart    # Lists notes, handles navigation to add/edit
│   └── add_edit_note_screen.dart # Form to add or update a note
├── widgets/
│   └── note_card.dart      # Reusable card widget for displaying note summaries
└── utils/
	└── date_formatter.dart # Utility for consistent date strings
assets/
└── icons/
	└── app_icon.png        # App launcher icon source
android/                    # Android-specific configs and build scripts
ios/                        # iOS-specific configs and build settings
web/                        # Web support assets (if targeting web)
windows/ linux/ macos/      # Desktop platform scaffolding
pubspec.yaml                # Dependencies, assets, and launcher icon config
analysis_options.yaml       # Static analysis rules (lints)
```

---

## Key Files

- `lib/main.dart`: Entry point; runs the app, sets up Flutter bindings, and loads the root widget defined in `app.dart`.
- `lib/app.dart`: Defines the MaterialApp, theme, and initial route to `HomeScreen`.
- `lib/database/database_helper.dart`: Creates/opens the SQLite database and exposes CRUD operations for notes.
- `lib/models/note_model.dart`: Defines the Note model and mapping to/from database rows.
- `lib/screens/home_screen.dart`: Displays the list of notes and navigation actions.
- `lib/screens/add_edit_note_screen.dart`: Form screen for creating or updating a note.
- `pubspec.yaml`: Declares Flutter SDK constraints, dependencies, assets, and launcher icon configuration.

---

## Prerequisites

- Flutter SDK (stable channel recommended)
- Dart (bundled with Flutter)
- Android Studio or VS Code with Flutter/Dart extensions
- Xcode (for iOS builds on macOS)
- Java JDK (for Android builds)

---

## Setup

1) Clone or download the repository.
2) Install dependencies:

```bash
flutter pub get
```

3) (Optional) Regenerate launcher icons after changing `assets/icons/app_icon.png`:

```bash
dart run flutter_launcher_icons
```

---

## Run

- Run on a connected device/emulator:

```bash
flutter run
```

- Web (for demo UI only; SQLite not supported in this setup):

```bash
flutter run -d chrome
```

- Build Android release APK:

```bash
flutter build apk --release
```

---

## Notes on Data Persistence

- Storage uses SQLite via `sqflite` and stores data locally on-device.
- No remote sync is included; this keeps the app offline-first and simple for portfolio use.

---

## Technologies

- Flutter (Material design widgets)
- Dart
- sqflite, path, path_provider (local database storage)
- intl (date formatting)
- flutter_launcher_icons (dev) for app icon generation

---

## Contribution & Learning

This project is structured for learning and demonstration. Feel free to extend it with:
- State management (e.g., Provider, Riverpod, or Bloc).
- Theming/dark mode.
- Search, filtering, and tagging for notes.
- Cloud sync (Firebase, Supabase) if you want multi-device support.
├── screens/
