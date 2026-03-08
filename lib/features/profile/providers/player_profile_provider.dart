import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuanquest/core/services/gamification_service.dart';
import 'package:cuanquest/domain/domain.dart';

class PlayerProfileNotifier extends Notifier<PlayerProfile> {
  @override
  PlayerProfile build() {
    final now = DateTime.now();
    final currentMonth =
        '${now.month.toString().padLeft(2, '0')}-${now.year}';
    return PlayerProfile(
      id: 'player_1',
      // Pre-seeded to match the 5 sample transactions in TransactionsNotifier:
      // 4 expenses (2 essential ×8 XP, 1 want ×5 XP, 1 essential ×8 XP)
      // + 1 salary income (15 XP) = 44 XP total, 1 want HP damage ≈ -4
      totalXp: 44,
      hp: 96,
      streakCount: 2,
      lastLogDate: DateTime(2000), // triggers streak check on first log
      lastActiveMonth: currentMonth,
    );
  }

  /// Apply a just-logged transaction: updates XP, HP, and streak.
  void applyTransaction(Transaction t) {
    _resetHpIfNewMonth();
    state = GamificationService.applyTransaction(state, t);
  }

  /// Call on app foreground to reset streak if the user missed a day.
  void checkStreak() {
    _resetHpIfNewMonth();
    state = GamificationService.checkStreak(state);
  }

  /// Resets HP to 100 if we've entered a new calendar month.
  void _resetHpIfNewMonth() {
    final now = DateTime.now();
    final currentMonth =
        '${now.month.toString().padLeft(2, '0')}-${now.year}';
    if (state.lastActiveMonth != currentMonth) {
      state = state.copyWith(hp: 100, lastActiveMonth: currentMonth);
    }
  }
}

final playerProfileProvider =
    NotifierProvider<PlayerProfileNotifier, PlayerProfile>(
  PlayerProfileNotifier.new,
);
