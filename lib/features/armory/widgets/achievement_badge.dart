import 'package:flutter/material.dart';
import 'package:cuanquest/core/core.dart';
import 'package:cuanquest/domain/domain.dart';

class AchievementBadge extends StatelessWidget {
  const AchievementBadge({super.key, required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unlocked = achievement.isUnlocked;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          left: BorderSide(
            color: unlocked ? AppColors.secondary : AppColors.borderMuted,
            width: 4,
          ),
          top: const BorderSide(color: AppColors.borderMuted),
          right: const BorderSide(color: AppColors.borderMuted),
          bottom: const BorderSide(color: AppColors.borderMuted),
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Opacity(
          opacity: unlocked ? 1.0 : 0.3,
          child: Text(
            achievement.emoji,
            style: const TextStyle(fontSize: 28),
          ),
        ),
        title: Text(
          achievement.name,
          style: theme.textTheme.titleSmall?.copyWith(
            color:
                unlocked ? AppColors.onBackground : AppColors.onSurface,
          ),
        ),
        subtitle: Text(
          achievement.description,
          style: theme.textTheme.bodySmall,
        ),
        trailing: unlocked
            ? const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 22,
              )
            : const Icon(
                Icons.lock_rounded,
                color: AppColors.borderMuted,
                size: 20,
              ),
      ),
    );
  }
}
