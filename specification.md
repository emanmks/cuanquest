# Specification: CuanQuest

## Project Overview
CuanQuest is a cross-platform gamified personal finance manager built with Flutter. It targets Gen-Z and Millennials by transforming the "chore" of budgeting into a "quest-based" RPG experience.

## Core Game Mechanics
- **The Mana Bar (Budget):** Your monthly allowance. Spending on non-essentials drains Mana.
- **XP (Experience Points):** Earned through consistent logging, staying under budget, and reaching savings milestones.
- **HP (Health Points):** A monthly "life" bar (Starts at 100). Overspending "damages" the player. If HP hits 0, the "Quest" for the month is failed.
- **Boss Battles:** A monthly summary screen where the user "fights" their total expenses. Victory is determined by the savings rate.
- **The Armory:** A locked wishlist. Real-world rewards (e.g., "New Shoes") are only "unlocked" for purchase once specific XP or Badge requirements are met.

## Technical Requirements
- **Framework:** Flutter (3.x or higher).
- **Platform Support:** Android, iOS, Web, Windows, macOS, Linux.
- **State Management:** Riverpod (Recommended) or BLoC.
- **Local Storage:** Drift (SQLite) or Hive for offline-first capability.
- **Theme:** "Neo-Brutalism" or "Cyber-Clean" (High contrast, bold borders, vibrant accents).
