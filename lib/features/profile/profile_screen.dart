import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuanquest/core/core.dart';
import 'package:cuanquest/domain/domain.dart';
import 'package:cuanquest/features/ledger/providers/transactions_provider.dart';
import 'package:cuanquest/features/profile/providers/player_profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final transactions = ref.watch(transactionsProvider);
    final theme = Theme.of(context);

    final level = GamificationService.levelFromTotalXp(profile.totalXp);
    final xpInLevel = GamificationService.xpInCurrentLevel(profile.totalXp);
    final xpNeeded = GamificationService.xpRequiredForLevel(level);
    final xpPct = xpInLevel / xpNeeded;
    final hpPct = profile.hp / 100;

    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (s, t) => s + t.amount);
    final totalExpense = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (s, t) => s + t.amount);
    final wantCount = transactions
        .where((t) => t.type == TransactionType.expense && !t.isEssential)
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Level card ──────────────────────────────────────────────────
          GameCard(
            borderColor: AppColors.tertiary,
            shadowColor: AppColors.tertiary,
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  color: AppColors.tertiaryContainer,
                  child: Center(
                    child: Text(
                      '$level',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ADVENTURER',
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: AppColors.onSurface, letterSpacing: 1.5),
                      ),
                      Text(
                        'Level $level',
                        style: theme.textTheme.titleLarge
                            ?.copyWith(color: AppColors.tertiary),
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: xpPct,
                        minHeight: 8,
                        backgroundColor: AppColors.surfaceVariant,
                        color: AppColors.tertiary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$xpInLevel / $xpNeeded XP',
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── HP card ─────────────────────────────────────────────────────
          GameCard(
            borderColor: AppColors.error,
            shadowColor: AppColors.error,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'HP — Health Points',
                      style: theme.textTheme.titleSmall,
                    ),
                    Text(
                      '${profile.hp} / 100',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: AppColors.error, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: hpPct,
                  minHeight: 10,
                  backgroundColor: AppColors.surfaceVariant,
                  color: _hpColor(profile.hp),
                ),
                const SizedBox(height: 6),
                Text(
                  profile.hp > 70
                      ? 'Looking healthy! Keep it up.'
                      : profile.hp > 40
                          ? 'Careful — avoid non-essential spending!'
                          : 'Critical! Your quest is in danger!',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: _hpColor(profile.hp)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Streak card ─────────────────────────────────────────────────
          GameCard(
            borderColor: AppColors.secondary,
            shadowColor: AppColors.secondary,
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  color: AppColors.secondaryContainer,
                  child: Center(
                    child: Text(
                      '🔥',
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${profile.streakCount}-Day Streak',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(color: AppColors.secondary),
                    ),
                    Text(
                      profile.streakCount >= 7
                          ? 'On fire! 🏆'
                          : 'Log daily to keep the streak!',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Stats ────────────────────────────────────────────────────────
          Text(
            'STATS',
            style: theme.textTheme.labelSmall
                ?.copyWith(color: AppColors.onSurface, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          _StatsRow(
            label: 'Total XP Earned',
            value: '${profile.totalXp} XP',
            color: AppColors.tertiary,
          ),
          _StatsRow(
            label: 'Total Income',
            value: 'Rp ${_fmt(totalIncome)}',
            color: AppColors.success,
          ),
          _StatsRow(
            label: 'Total Expenses',
            value: 'Rp ${_fmt(totalExpense)}',
            color: AppColors.error,
          ),
          _StatsRow(
            label: 'Transactions Logged',
            value: '${transactions.length}',
            color: AppColors.primary,
          ),
          _StatsRow(
            label: 'Want Purchases',
            value: '$wantCount',
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  static Color _hpColor(int hp) {
    if (hp > 60) return AppColors.success;
    if (hp > 30) return AppColors.tertiary;
    return AppColors.error;
  }

  static String _fmt(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          left: BorderSide(color: AppColors.borderMuted, width: 3),
          top: BorderSide(color: AppColors.borderMuted),
          right: BorderSide(color: AppColors.borderMuted),
          bottom: BorderSide(color: AppColors.borderMuted),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: theme.textTheme.titleSmall
                ?.copyWith(color: color, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
