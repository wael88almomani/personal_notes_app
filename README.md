# Personal Notes App

A feature-rich Flutter notes application for creating, organizing, and customizing personal notes with advanced text formatting and Arabic fonts support. Built as an academic/portfolio project demonstrating mobile UI design, state management, offline persistence with SQLite, and modern Flutter best practices.

**Current Version:** v1.2.0+5

---

## Features

### Core Functionality
- ✅ Create, edit, and delete text notes
- ✅ Local SQLite storage (works offline)
- ✅ Search notes by title or content
- ✅ Pin/Unpin important notes to keep them at the top
- ✅ Sort by last modified date
- ✅ Friendly date formatting for created/updated timestamps

### Customization & Styling
- 🎨 **9 Note Colors**: Choose from default white, red, orange, yellow, green, teal, blue, purple, and pink
- 🔤 **Font Size Control**: Adjust text size from 12pt to 24pt with a slider
- ✍️ **8 Arabic Fonts**: 
  - Default (system font)
  - **Scheherazade New** (with Tashkeel/diacritics support)
  - **Harmattan** (with Tashkeel/diacritics support)
  - Amiri
  - Cairo
  - Tajawal
  - El Messiri
  - Lateef
- 🌈 **7 Text Colors**: Black, White, Red, Blue, Green, Purple, Orange

### Sharing & Integration
- 📤 Share notes as plain text to WhatsApp, Facebook, Messenger, and other apps
- 📱 Native sharing integration using device share sheet

---

## Project Structure

```
lib/
├── main.dart               # App entry point; wires Flutter bindings, theme, and initial route
├── app.dart                # App widget tree and navigation setup
├── models/
│   └── note_model.dart     # Note data model with formatting options (color, font, size)
├── database/
│   └── database_helper.dart# SQLite v3 with Pin, Color, and Font customization support
├── screens/
│   ├── home_screen.dart    # Lists notes with search, pin functionality, and color preview
│   └── add_edit_note_screen.dart # Rich text editor with font/color controls and share button
├── widgets/
│   └── note_card.dart      # Reusable card widget displaying note with custom styling
└── utils/
    └── date_formatter.dart # Utility for consistent date strings
assets/
└── icons/
    └── app_icon.png        # App launcher icon source
android/                    # Android-specific configs and build scripts
ios/                        # iOS-specific configs and build settings
web/                        # Web support assets (if targeting web)
windows/ linux/ macos/      # Desktop platform scaffolding
pubspec.yaml                # Dependencies: sqflite, google_fonts, share_plus, intl
analysis_options.yaml       # Static analysis rules (lints)
```

---

## Key Files

- `lib/main.dart`: Entry point; runs the app, sets up Flutter bindings, and loads the root widget defined in `app.dart`.
- `lib/app.dart`: Defines the MaterialApp, theme, and initial route to `HomeScreen`.
- `lib/database/database_helper.dart`: Creates/opens SQLite database (v3) with automatic migration support. Handles CRUD operations for notes with Pin, Color, and Font customization fields.
- `lib/models/note_model.dart`: Defines the Note model with 11 fields including id, title, content, timestamps, isPinned, colorCode, fontSize, fontFamily, and textColor.
- `lib/screens/home_screen.dart`: Main screen displaying notes list with search bar, pin functionality, and color-coded cards. Loads notes on init and handles refresh.
- `lib/screens/add_edit_note_screen.dart`: Rich text editor with real-time formatting controls (font size slider, font family selection with Google Fonts preview, text color picker) and share button.
- `lib/widgets/note_card.dart`: Reusable Material card widget displaying note preview with custom font styling and Google Fonts support.
- `pubspec.yaml`: Declares Flutter SDK constraints, core dependencies (sqflite, path_provider, intl) and new packages (google_fonts, share_plus).

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

- **Flutter** (Material Design 3 widgets)
- **Dart** (3.10.8)
- **sqflite** (^2.3.2) - Local SQLite database with automatic migrations
- **path_provider** (^2.1.2) - Cross-platform path access
- **intl** (^0.19.0) - Date formatting and internationalization
- **google_fonts** (^6.3.3) - High-quality Arabic fonts rendering (Scheherazade New, Harmattan, Amiri, Cairo, etc.)
- **share_plus** (^10.1.4) - Native share functionality for cross-app sharing
- **flutter_launcher_icons** (dev) - App icon generation

## Database Schema

**Notes Table (v3):**
- `id` INTEGER PRIMARY KEY
- `title` TEXT
- `content` TEXT
- `created_date` TEXT (ISO 8601)
- `last_modified` TEXT (ISO 8601)
- `is_pinned` INTEGER (0 or 1)
- `color_code` TEXT (default, red, orange, yellow, green, teal, blue, purple, pink)
- `font_size` REAL (12.0 - 24.0)
- `font_family` TEXT (default, Scheherazade New, Harmattan, Amiri, Cairo, Tajawal, ElMessiri, Lateef)
- `text_color` TEXT (black, white, red, blue, green, purple, orange)

Migration support from v1 → v2 → v3 with ALTER TABLE statements.

---

## Version History

### v1.2.0+5 (February 2026)
- ✨ Added 8 Arabic fonts with Google Fonts integration
- ✨ Font customization: size (12-24pt), family, and color controls
- ✨ Share notes feature (WhatsApp, Facebook, Messenger, etc.)
- ✨ Scheherazade New & Harmattan fonts with full Tashkeel/diacritics support
- 🔧 Database upgraded to v3 with font customization fields
- 🎨 Live text preview with formatting in editor
- 🐛 Bug fixes and performance improvements

### v1.1.0+4 (February 2026)
- ✨ Pin/Unpin notes functionality
- ✨ 9 customizable note colors
- ✨ Search notes by title or content
- ✨ Last modified date tracking
- 🔧 Database upgraded to v2 with automatic migration
- 🎨 Improved UI with color-coded note cards
- 🐛 Fixed: Notes not loading on app startup

### v1.0.1+3 (January 2026)
- 🎉 Initial release
- Basic note creation, editing, and deletion
- Local SQLite storage
- Simple Material UI design



