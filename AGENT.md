# AGENT.md: Development Guidelines for CuanQuest

To any Agent (AI) generating code for this project, please adhere to the following:

## Architecture & State
- **State Management:** Use **Riverpod**. State should be immutable.
- **Responsiveness:** Use `LayoutBuilder` or `MediaQuery` to ensure the UI scales from mobile to wide-screen desktop.
- **Domain Logic:** Keep game-related calculations (XP formulas, HP loss) in pure Dart classes (Domain layer), separate from Flutter Widgets.

## UI/UX Guidelines
- **Terminology:** Use "Cuan" for Income, "Mana Drain" for Expenses, and "Loot" for Savings.
- **Haptic Feedback:** Trigger `HapticFeedback.lightImpact()` on success and `HapticFeedback.vibrate()` on overspending.
- **Visuals:** Use high-contrast borders (2px+) and rounded corners (12-20px).

## Code Style
- Use `final` where possible.
- Document every public method in the Game Engine.
- Ensure all UI widgets are `const` when applicable to optimize performance across all 7+ platforms.
