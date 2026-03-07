import 'package:flutter/material.dart';
import 'package:cuanquest/core/core.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CuanQuest'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              'LVL 1',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.tertiary,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Mana / HP bar preview
          GameCard(
            shadowColor: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MANA BAR', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.onSurface)),
                const SizedBox(height: 4),
                Text('Monthly Budget', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                const LinearProgressIndicator(
                  value: 0.6,
                  minHeight: 12,
                  backgroundColor: AppColors.surfaceVariant,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 4),
                Text('60% spent', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // HP card
          GameCard(
            shadowColor: AppColors.error,
            borderColor: AppColors.error,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HP', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.onSurface)),
                const SizedBox(height: 4),
                Text('Health Points', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                const LinearProgressIndicator(
                  value: 0.85,
                  minHeight: 12,
                  backgroundColor: AppColors.surfaceVariant,
                  color: AppColors.error,
                ),
                const SizedBox(height: 4),
                Text('85 / 100 HP', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // XP card
          GameCard(
            shadowColor: AppColors.tertiary,
            borderColor: AppColors.tertiary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('XP', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.onSurface)),
                const SizedBox(height: 4),
                Text('Experience Points', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                const LinearProgressIndicator(
                  value: 0.3,
                  minHeight: 12,
                  backgroundColor: AppColors.surfaceVariant,
                  color: AppColors.tertiary,
                ),
                const SizedBox(height: 4),
                Text('300 / 1000 XP', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GameButton(
            label: 'LOG TRANSACTION',
            icon: Icons.add_rounded,
            expanded: true,
            onPressed: () {},
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
}
