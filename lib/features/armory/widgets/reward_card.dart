import 'package:flutter/material.dart';
import 'package:cuanquest/core/core.dart';
import 'package:cuanquest/domain/domain.dart';

class RewardCard extends StatelessWidget {
  const RewardCard({
    super.key,
    required this.reward,
    required this.totalXp,
    required this.onDelete,
  });

  final Reward reward;
  final int totalXp;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unlocked = reward.isUnlocked(totalXp);
    final xpNeeded = reward.xpNeeded(totalXp);

    return GameCard(
      borderColor: unlocked ? AppColors.tertiary : AppColors.borderMuted,
      shadowColor: unlocked ? AppColors.tertiary : AppColors.borderMuted,
      padding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Emoji — faded when locked
                  Opacity(
                    opacity: unlocked ? 1.0 : 0.35,
                    child: Text(
                      reward.imagePath,
                      style: const TextStyle(fontSize: 42),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Name
                  Text(
                    reward.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: unlocked
                          ? AppColors.onBackground
                          : AppColors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // XP cost
                  Text(
                    '${reward.xpCost} XP',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: unlocked
                          ? AppColors.tertiary
                          : AppColors.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Status
                  if (unlocked)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.tertiaryContainer,
                        border: Border.all(color: AppColors.tertiary),
                      ),
                      child: const Text(
                        'UNLOCKED ✓',
                        style: TextStyle(
                          color: AppColors.tertiary,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        const Icon(
                          Icons.lock_rounded,
                          color: AppColors.borderMuted,
                          size: 18,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '+$xpNeeded XP needed',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 9,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // Delete button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onDelete,
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.borderMuted,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
