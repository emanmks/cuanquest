# Database: CuanQuest

CuanQuest uses [Drift](https://drift.simonbinder.eu/) (a type-safe SQLite wrapper) via the `drift_flutter` package, which automatically selects the right storage backend per platform.

---

## Schema

Five tables, all defined in `lib/data/database/app_database.dart`:

| Table | Key columns | Purpose |
|-------|-------------|---------|
| `player_profiles` | `id`, `total_xp`, `hp`, `streak_count`, `last_log_date`, `last_active_month` | Single-row player state |
| `transactions` | `id`, `amount`, `category`, `type`, `is_essential`, `note`, `created_at`, `month_year` | Full spending/income history |
| `rewards` | `id`, `name`, `xp_cost`, `image_path` | Armory wishlist items |
| `budget_categories` | `id`, `name`, `emoji`, `month_year` | Custom budget categories per month |
| `budget_posts` | `id`, `category_id`, `name`, `type`, `amount`, `month_year` | Fixed/max spending posts per category |

The generated code lives in `lib/data/database/app_database.g.dart` (do not edit manually — regenerate with `dart run build_runner build`).

---

## Storage location by platform

### macOS
```
~/Library/Containers/<bundle-id>/Data/Documents/cuanquest.sqlite
```
Sandboxed per app bundle. Survives system updates and app updates. Only wiped on app uninstall or manual deletion.

### iOS
```
<app-sandbox>/Documents/cuanquest.sqlite
```
Inside the app's private sandbox. iCloud Backup includes this directory by default unless opted out. Wiped on uninstall; preserved through App Store updates.

### Android
```
/data/data/<package-name>/app_flutter/cuanquest.sqlite
```
Private app storage — not accessible without root. Preserved through Play Store updates. Wiped on uninstall; can be preserved via Android Backup.

### Linux
```
~/.local/share/<app-name>/cuanquest.sqlite
```
Follows the XDG Base Directory spec via `path_provider`. No automatic backup.

### Windows
```
C:\Users\<user>\Documents\cuanquest.sqlite
```
Resolved by `getApplicationDocumentsDirectory()`. No automatic backup.

### Web

No file is written. `drift_flutter` calls `WasmDatabase.open()` which picks the best available browser storage backend in this order:

| Priority | Backend | Requirement | Notes |
|----------|---------|-------------|-------|
| 1 | **OPFS** (Origin Private File System) | Chrome 102+, Firefox 111+ + COOP/COEP headers | Fastest, fully sandboxed |
| 2 | **IndexedDB + SharedArrayBuffer** | SharedArrayBuffer available | Hybrid fallback |
| 3 | **IndexedDB** | Any modern browser | Always available, slowest |

Drift logs the chosen backend at startup, e.g.:
```
Using opfs due to missing browser features: []
Using indexedDb due to missing browser features: [sharedMemory]
```

**Data is scoped to the origin** — `http://localhost:5000` and `https://cuanquest.app` are completely separate databases.

**COOP/COEP headers for OPFS** — required on your web server to enable the fastest backend:
```
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy: require-corp
```
Without these headers, drift falls back to IndexedDB automatically.

---

## What happens when you ship a new version?

### Short answer: data is never reset automatically.

App updates (Play Store, App Store, direct binary replacement) preserve the database file. The OS protects the app's data directory during updates. On web, browser storage is preserved unless the user explicitly clears it.

### The only mechanism that affects data: `schemaVersion`

`schemaVersion` is declared in `app_database.dart`:

```dart
@override
int get schemaVersion => 1;
```

This integer is stored inside the SQLite file itself. On every app launch, Drift compares the stored version against the declared version:

| Situation | Drift behaviour |
|-----------|----------------|
| Versions match | Opens normally. All data intact. |
| Stored version < declared version | Calls `onUpgrade`. If not defined, no-op (may break at runtime if new columns are missing). |
| Stored version > declared version | Calls `onDowngrade`. If not defined, throws an exception. |
| Database does not exist yet | Calls `onCreate`. Creates all tables fresh. |

### How to add a column or table safely

1. Make the schema change in `app_database.dart`
2. Bump `schemaVersion`
3. Add an `onUpgrade` handler:

```dart
@override
int get schemaVersion => 2;

@override
MigrationStrategy get migration => MigrationStrategy(
  onUpgrade: (m, from, to) async {
    if (from < 2) {
      // Example: new column added to transactions
      await m.addColumn(transactions, transactions.someNewColumn);
    }
  },
);
```

Drift's migrator supports `addColumn`, `createTable`, `deleteTable`, `renameColumn`, and raw `customStatement` for anything else.

### During early development (no real users yet)

If the schema is still evolving and there's no production data to protect, the fastest reset is:

```bash
# macOS — delete and let onCreate rebuild
find ~/Library/Containers -name "cuanquest.sqlite" -delete

# Android (via adb)
adb shell rm /data/data/<package>/app_flutter/cuanquest.sqlite

# iOS simulator
# Device & Simulators → select simulator → Delete → re-run

# Web
# DevTools → Application → Storage → Clear site data
```

---

## Web asset files

Two files in `web/` are required for Drift to run in the browser:

| File | Purpose | How to update |
|------|---------|---------------|
| `web/sqlite3.wasm` | Compiled SQLite engine for WebAssembly | Download from [sqlite3.dart releases](https://github.com/simolus3/sqlite3.dart/releases) — match the tag to your `sqlite3` package version |
| `web/drift_worker.js` | JS worker compiled from `web/drift_worker.dart` | Run `dart compile js -O2 web/drift_worker.dart -o web/drift_worker.js` |

These files are committed to the repository and do not need to be regenerated on every build. Only update them when upgrading the `drift` or `sqlite3` packages.
