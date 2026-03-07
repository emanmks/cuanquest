# Deliveries: CuanQuest Roadmap

Slicing strategy: Atomic, incremental deliveries to ensure cross-platform UI stability before logic complexity.

## Milestone 1: The UI Shell (Skeleton)
- **DEL-1.1: Project Initialization**
  - Setup Flutter project with `flutter create`.
  - Configure folder structure: `lib/core`, `lib/features`, `lib/domain`.
  - Add `responsive_framework` and basic linting.
- **DEL-1.2: The Responsive Shell**
  - Implement a `Scaffold` that switches between `BottomNavigationBar` (Mobile) and `NavigationRail` (Tablet/Desktop).
  - Placeholder routes for: Dashboard, Ledger, Armory, and Profile.
- **DEL-1.3: Visual Identity (Theming)**
  - Define `ThemeData` with Gen-Z aesthetic (e.g., Purple/Teal/Yellow palette).
  - Implement custom "Game-style" buttons and cards with bold shadows.

## Milestone 2: Ledger & Transactions
- **DEL-2.1: Transaction Models**
  - Create the `Transaction` entity and Category enums.
- **DEL-2.2: The Ledger View**
  - A list view of transactions with "Essential" vs "Want" labels.
- **DEL-2.3: Transaction Entry UI**
  - A bottom sheet or modal to quickly log "Cuan" (Income) or "Mana Drain" (Expense).

## Milestone 3: Gamification Engine
- **DEL-3.1: XP & HP Logic**
  - Service class to calculate XP gain/loss based on transaction data.
- **DEL-3.2: Streak Tracker**
  - Logic to check consecutive days of under-budget spending.
- **DEL-3.3: Leveling System**
  - UI for the "Level Up" animation and Progress Bar.

## Milestone 4: The Armory (Rewards)
- **DEL-4.1: Wishlist Manager**
  - UI to add "Self-Rewards" with target XP costs.
- **DEL-4.2: Achievement System**
  - Badge logic (e.g., "7-Day No Spend Streak").
