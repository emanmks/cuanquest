import 'package:cuanquest/domain/domain.dart';

/// Pure stateless service — no Flutter or Riverpod deps.
class GamificationService {
  GamificationService._();

  // ── XP constants ──────────────────────────────────────────────────────────
  static const int _xpPerLog = 5;
  static const int _xpEssentialBonus = 3;
  static const int _xpIncomeBonus = 10;

  // ── HP constants ──────────────────────────────────────────────────────────
  // Default monthly budget used for HP damage scaling.
  // Will be replaced by Quest.monthlyLimit in a future delivery.
  static const double defaultMonthlyBudget = 3000000;

  // ── Level curve ───────────────────────────────────────────────────────────
  /// XP required to complete level [level] and advance to the next.
  static int xpRequiredForLevel(int level) => level * 150;

  /// Derive current level from lifetime [totalXp].
  static int levelFromTotalXp(int totalXp) {
    var level = 1;
    var remaining = totalXp;
    while (remaining >= xpRequiredForLevel(level)) {
      remaining -= xpRequiredForLevel(level);
      level++;
    }
    return level;
  }

  /// XP accumulated within the current level (resets at each level-up).
  static int xpInCurrentLevel(int totalXp) {
    var level = 1;
    var remaining = totalXp;
    while (remaining >= xpRequiredForLevel(level)) {
      remaining -= xpRequiredForLevel(level);
      level++;
    }
    return remaining;
  }

  /// Progress ratio (0.0–1.0) within the current level.
  static double xpProgress(int totalXp) {
    final level = levelFromTotalXp(totalXp);
    final current = xpInCurrentLevel(totalXp);
    return current / xpRequiredForLevel(level);
  }

  // ── XP calculation ────────────────────────────────────────────────────────
  static int xpGainForTransaction(Transaction t) {
    var xp = _xpPerLog;
    if (t.type == TransactionType.income) xp += _xpIncomeBonus;
    if (t.type == TransactionType.expense && t.isEssential) {
      xp += _xpEssentialBonus;
    }
    return xp;
  }

  // ── HP calculation ────────────────────────────────────────────────────────
  /// Only "Want" expenses (non-essential) drain HP.
  static int hpDamageForTransaction(
    Transaction t, {
    double monthlyBudget = defaultMonthlyBudget,
  }) {
    if (t.type == TransactionType.income || t.isEssential) return 0;
    final pct = t.amount / monthlyBudget;
    return (pct * 60).clamp(1.0, 20.0).round();
  }

  // ── Profile mutation (pure) ───────────────────────────────────────────────
  static PlayerProfile applyTransaction(
    PlayerProfile profile,
    Transaction t,
  ) {
    final xpGain = xpGainForTransaction(t);
    final hpDmg = hpDamageForTransaction(t);
    final newTotalXp = profile.totalXp + xpGain;
    final newHp = (profile.hp - hpDmg).clamp(0, 100);

    // Streak: increment if last log was yesterday, reset if older, hold if today
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastLogDay = DateTime(
      profile.lastLogDate.year,
      profile.lastLogDate.month,
      profile.lastLogDate.day,
    );
    final yesterday = today.subtract(const Duration(days: 1));

    final int newStreak;
    if (lastLogDay == today) {
      newStreak = profile.streakCount; // already logged today
    } else if (lastLogDay == yesterday) {
      newStreak = profile.streakCount + 1; // consecutive day
    } else {
      newStreak = 1; // streak broken
    }

    return profile.copyWith(
      totalXp: newTotalXp,
      hp: newHp,
      streakCount: newStreak,
      lastLogDate: now,
    );
  }

  /// Call on app resume to reset streak if the user missed a day.
  static PlayerProfile checkStreak(PlayerProfile profile) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastLogDay = DateTime(
      profile.lastLogDate.year,
      profile.lastLogDate.month,
      profile.lastLogDate.day,
    );
    final yesterday = today.subtract(const Duration(days: 1));

    if (lastLogDay == today || lastLogDay == yesterday) return profile;
    return profile.copyWith(streakCount: 0);
  }
}
