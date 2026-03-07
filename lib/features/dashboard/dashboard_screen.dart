import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuanquest/core/core.dart';
import 'package:cuanquest/domain/domain.dart';
import 'package:cuanquest/features/ledger/providers/transactions_provider.dart';
import 'package:cuanquest/features/ledger/widgets/add_transaction_sheet.dart';
import 'package:cuanquest/features/profile/providers/player_profile_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const double _monthlyBudget = GamificationService.defaultMonthlyBudget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final transactions = ref.watch(transactionsProvider);
    final theme = Theme.of(context);

    final level = GamificationService.levelFromTotalXp(profile.totalXp);
    final xpInLevel = GamificationService.xpInCurrentLevel(profile.totalXp);
    final xpNeeded = GamificationService.xpRequiredForLevel(level);
    final xpProgress = GamificationService.xpProgress(profile.totalXp);

    final totalSpent = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (s, t) => s + t.amount);
    final manaPct = (totalSpent / _monthlyBudget).clamp(0.0, 1.0);
    final manaRemaining = (_monthlyBudget - totalSpent).clamp(0.0, _monthlyBudget);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CuanQuest'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(
                  '${profile.streakCount}',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: AppColors.secondary),
                ),
                const SizedBox(width: 12),
                Text(
                  'LVL $level',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: AppColors.tertiary),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Mana Bar ────────────────────────────────────────────────────
          GameCard(
            shadowColor: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MANA BAR',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurface,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      '${(manaPct * 100).toStringAsFixed(0)}% spent',
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Monthly Budget', style: theme.textTheme.titleLarge),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: manaPct,
                  minHeight: 12,
                  backgroundColor: AppColors.surfaceVariant,
                  color: manaPct > 0.8 ? AppColors.error : AppColors.primary,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rp ${_fmt(manaRemaining)} left',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      '/ Rp ${_fmt(_monthlyBudget)}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.onSurface),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── HP + XP row ─────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: GameCard(
                  borderColor: AppColors.error,
                  shadowColor: AppColors.error,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HP',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurface,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        '${profile.hp}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: profile.hp / 100,
                        minHeight: 8,
                        backgroundColor: AppColors.surfaceVariant,
                        color: AppColors.error,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GameCard(
                  borderColor: AppColors.tertiary,
                  shadowColor: AppColors.tertiary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'XP  LVL $level',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.tertiary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        '$xpInLevel',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppColors.tertiary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: xpProgress,
                        minHeight: 8,
                        backgroundColor: AppColors.surfaceVariant,
                        color: AppColors.tertiary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '/ $xpNeeded XP',
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Actions ──────────────────────────────────────────────────────
          GameButton(
            label: 'LOG TRANSACTION',
            icon: Icons.bolt_rounded,
            expanded: true,
            onPressed: () => _openSheet(context),
          ),
          const SizedBox(height: 12),
          GameButton(
            label: 'VIEW ARMORY',
            icon: Icons.shield_rounded,
            expanded: true,
            color: AppColors.secondary,
            textColor: AppColors.onSecondary,
            borderColor: AppColors.border,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void _openSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => const AddTransactionSheet(),
    );
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
