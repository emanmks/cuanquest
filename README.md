# CuanQuest

A gamified personal finance manager built with Flutter. Track spending, earn XP, maintain streaks, and unlock rewards — personal finance as an RPG.

## Documentation

| File | Contents |
|------|----------|
| **[README.md](README.md)** | This file — setup, build instructions, project structure, game mechanics |
| **[database.md](database.md)** | Database storage per platform (macOS/iOS/Android/Linux/Windows/Web), schema migrations, versioning, and web WASM assets |
| **[specification.md](specification.md)** | Product vision, core game mechanic definitions, technical requirements |
| **[entities.md](entities.md)** | Original domain entity schemas (PlayerProfile, Transaction, Reward, Quest) |
| **[deliveries.md](deliveries.md)** | Milestone roadmap — DEL-1.x through DEL-4.x and beyond |
| **[AGENT.md](AGENT.md)** | Guidelines for AI agents contributing code to this project |

## Features

- **Mana Bar** — monthly budget visualized as a mana meter; non-essential spending drains it
- **XP & Leveling** — earn XP for every logged transaction; level up with an animated dialog
- **HP System** — take damage for impulsive "want" purchases; HP resets at the start of each month
- **Streak Tracking** — daily logging streaks shown in the app bar
- **Ledger** — full transaction log grouped by date; swipe to delete, tap to edit
- **Armory** — wishlist of real-life goals unlocked with XP; 9 achievement badges
- **Budget Planner** — custom budget categories (emoji + name) with fixed/max spending posts; pie chart on dashboard
- **Month Navigation** — browse any month's transactions and budget with `[<] March 2026 [>]`
- **Responsive Shell** — NavigationBar on mobile, NavigationRail on tablet/desktop

## Tech Stack

| Concern | Package |
|---------|---------|
| State management | `flutter_riverpod` + `riverpod_annotation` |
| Navigation | `go_router` |
| Local database | `drift` + `drift_flutter` + `sqlite3_flutter_libs` |
| Charts | `fl_chart` |
| Responsive layout | `responsive_framework` |
| Typography | `google_fonts` (Space Grotesk) |
| Code generation | `build_runner` + `drift_dev` + `riverpod_generator` |

## Project Structure

```
lib/
├── core/
│   ├── providers/          # database_provider, selected_month_provider
│   ├── router/             # app_router.dart (GoRouter)
│   ├── services/           # gamification_service, achievement_service
│   ├── shell/              # app_shell.dart (responsive nav wrapper)
│   ├── theme/              # app_colors, app_theme (Neo-Brutalism dark)
│   └── widgets/            # game_card, game_button, level_up_dialog, month_navigator
├── data/
│   └── database/           # app_database.dart (Drift schema + generated .g.dart)
├── domain/
│   └── entities/           # PlayerProfile, Transaction, Reward, Quest,
│                           # Achievement, BudgetCategory, BudgetPost
└── features/
    ├── armory/             # Wishlist + badges screen
    ├── budget/             # Budget screen, categories, posts, providers
    ├── dashboard/          # Dashboard + BudgetPieChart widget
    ├── ledger/             # Transaction list + add/edit sheet
    └── profile/            # Profile screen + PlayerProfileNotifier
```

## Getting Started

### Prerequisites

- Flutter SDK `^3.11.0`
- Dart SDK `^3.11.0`
- Xcode (for iOS / macOS builds)
- Android Studio / Android SDK (for Android builds)

### Install dependencies & generate code

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

> Re-run `build_runner` any time you modify `app_database.dart` or add/remove Riverpod providers.

### Run in development

```bash
# Pick a device
flutter devices

# macOS desktop (recommended for development)
flutter run -d macos

# Web (Chrome)
flutter run -d chrome

# iOS simulator
flutter run -d <simulator-id>

# Android emulator
flutter run -d <emulator-id>
```

---

## Building for Release

### iOS

1. Open `ios/Runner.xcworkspace` in Xcode and set your Team & Bundle ID.
2. Build the archive:

```bash
flutter build ipa
```

The `.ipa` is output to `build/ios/ipa/`. Upload via Xcode Organizer or `xcrun altool`.

> Requires a paid Apple Developer account for device/App Store distribution.

---

### macOS

```bash
flutter build macos
```

Output: `build/macos/Build/Products/Release/cuanquest.app`

To distribute outside the Mac App Store, notarize the app:

```bash
# Codesign
codesign --deep --force --verify --verbose \
  --sign "Developer ID Application: <Your Name> (<Team ID>)" \
  build/macos/Build/Products/Release/cuanquest.app

# Notarize (requires app-specific password)
xcrun notarytool submit cuanquest.zip \
  --apple-id <email> --password <app-password> --team-id <Team ID> --wait

xcrun stapler staple build/macos/Build/Products/Release/cuanquest.app
```

---

### Android

1. Create a keystore if you don't have one:

```bash
keytool -genkey -v -keystore ~/cuanquest.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias cuanquest
```

2. Create `android/key.properties`:

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=cuanquest
storeFile=<path-to>/cuanquest.jks
```

3. Build:

```bash
# App Bundle (recommended for Play Store)
flutter build appbundle

# APK (for direct install)
flutter build apk --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

### Web

The web build requires `sqlite3.wasm` and `drift_worker.js` in the `web/` folder (already committed).

```bash
flutter build web --release
```

Output: `build/web/` — deploy the entire folder to any static host (Vercel, Netlify, Firebase Hosting, GitHub Pages, etc.).

#### Re-generating web assets

If you upgrade the `sqlite3` or `drift` packages, regenerate the web assets:

```bash
# 1. Download the matching sqlite3.wasm from:
#    https://github.com/simolus3/sqlite3.dart/releases
#    Match the tag to your sqlite3 package version (e.g. sqlite3-2.9.4)
curl -L https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-<VERSION>/sqlite3.wasm \
  -o web/sqlite3.wasm

# 2. Recompile the drift worker
dart compile js -O2 web/drift_worker.dart -o web/drift_worker.js
```

---

## Development Notes

### Code generation

This project uses `build_runner` for two generators:

| Generator | Generates |
|-----------|-----------|
| `drift_dev` | `lib/data/database/app_database.g.dart` |
| `riverpod_generator` | `*.g.dart` for `@riverpod` annotated providers |

Run after any schema or provider changes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Linting

```bash
flutter analyze
dart run custom_lint
```

### Game mechanics reference

| Mechanic | Rule |
|----------|------|
| XP per essential expense | +8 XP |
| XP per want expense | +5 XP |
| XP per income | +15 XP |
| HP damage per want expense | −(amount / budget × 20), min −2 |
| XP to level up | Level × 150 XP |
| HP reset | Resets to 100 at the start of each new month |
| Streak | +1 if logged yesterday; resets if a day is missed |
