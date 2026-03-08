import 'package:cuanquest/core/services/gamification_service.dart';
import 'package:cuanquest/domain/domain.dart';

/// Pure stateless service — derives badge unlock state from current app state.
class AchievementService {
  AchievementService._();

  static List<Achievement> compute(
    PlayerProfile profile,
    List<Transaction> transactions,
  ) {
    final level = GamificationService.levelFromTotalXp(profile.totalXp);
    final wantCount = transactions
        .where((t) => t.type == TransactionType.expense && !t.isEssential)
        .length;
    final hasLargeIncome = transactions.any(
      (t) => t.type == TransactionType.income && t.amount >= 1000000,
    );
    final essentialCount = transactions
        .where((t) => t.type == TransactionType.expense && t.isEssential)
        .length;

    return [
      Achievement(
        id: 'first_quest',
        name: 'First Quest',
        description: 'Log your first transaction',
        emoji: '📝',
        isUnlocked: transactions.isNotEmpty,
      ),
      Achievement(
        id: 'streak_3',
        name: 'On a Roll',
        description: 'Maintain a 3-day logging streak',
        emoji: '🔥',
        isUnlocked: profile.streakCount >= 3,
      ),
      Achievement(
        id: 'streak_7',
        name: 'Week Warrior',
        description: 'Maintain a 7-day logging streak',
        emoji: '⚔️',
        isUnlocked: profile.streakCount >= 7,
      ),
      Achievement(
        id: 'level_3',
        name: 'Rising Hero',
        description: 'Reach Level 3',
        emoji: '⭐',
        isUnlocked: level >= 3,
      ),
      Achievement(
        id: 'level_5',
        name: 'Seasoned Adventurer',
        description: 'Reach Level 5',
        emoji: '🌟',
        isUnlocked: level >= 5,
      ),
      Achievement(
        id: 'essential_master',
        name: 'Essential Master',
        description: 'Log 5 essential expenses',
        emoji: '🛡️',
        isUnlocked: essentialCount >= 5,
      ),
      Achievement(
        id: 'consistent_10',
        name: 'Consistent Logger',
        description: 'Log 10 transactions total',
        emoji: '📊',
        isUnlocked: transactions.length >= 10,
      ),
      Achievement(
        id: 'cuan_master',
        name: 'Cuan Master',
        description: 'Log income of Rp 1,000,000 or more',
        emoji: '💰',
        isUnlocked: hasLargeIncome,
      ),
      Achievement(
        id: 'discipline',
        name: 'Iron Discipline',
        description: 'Have zero Want purchases on record',
        emoji: '🏆',
        isUnlocked: transactions.isNotEmpty && wantCount == 0,
      ),
    ];
  }
}
