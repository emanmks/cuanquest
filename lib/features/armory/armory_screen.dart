import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuanquest/core/core.dart';
import 'package:cuanquest/domain/domain.dart';
import 'package:cuanquest/features/armory/providers/achievements_provider.dart';
import 'package:cuanquest/features/armory/providers/rewards_provider.dart';
import 'package:cuanquest/features/armory/widgets/achievement_badge.dart';
import 'package:cuanquest/features/armory/widgets/add_reward_sheet.dart';
import 'package:cuanquest/features/armory/widgets/reward_card.dart';
import 'package:cuanquest/features/profile/providers/player_profile_provider.dart';

class ArmoryScreen extends ConsumerStatefulWidget {
  const ArmoryScreen({super.key});

  @override
  ConsumerState<ArmoryScreen> createState() => _ArmoryScreenState();
}

class _ArmoryScreenState extends ConsumerState<ArmoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(playerProfileProvider);
    final rewards = ref.watch(rewardsProvider);
    final achievements = ref.watch(achievementsProvider);

    final unlockedRewards =
        rewards.where((r) => r.isUnlocked(profile.totalXp)).length;
    final unlockedBadges = achievements.where((a) => a.isUnlocked).length;

    final onWishlistTab = _tabController.index == 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Armory'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurface,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            fontSize: 12,
          ),
          tabs: [
            Tab(text: 'WISHLIST  $unlockedRewards/${rewards.length}'),
            Tab(text: 'BADGES  $unlockedBadges/${achievements.length}'),
          ],
        ),
      ),
      floatingActionButton: onWishlistTab
          ? FloatingActionButton(
              onPressed: () => _openAddSheet(context),
              backgroundColor: AppColors.secondary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              child: const Icon(Icons.add_rounded, color: Colors.black),
            )
          : null,
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── Wishlist tab ─────────────────────────────────────────────────
          _WishlistTab(
            rewards: rewards,
            totalXp: profile.totalXp,
            onDelete: (id) =>
                ref.read(rewardsProvider.notifier).remove(id),
          ),

          // ── Badges tab ───────────────────────────────────────────────────
          _BadgesTab(achievements: achievements),
        ],
      ),
    );
  }

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => const AddRewardSheet(),
    );
  }
}

// ── Wishlist tab ──────────────────────────────────────────────────────────────

class _WishlistTab extends StatelessWidget {
  const _WishlistTab({
    required this.rewards,
    required this.totalXp,
    required this.onDelete,
  });

  final List<Reward> rewards;
  final int totalXp;
  final void Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (rewards.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🛡️', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text('Armory is empty', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Add your real-life goals and unlock them with XP!',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth < 500
            ? 2
            : constraints.maxWidth < 900
                ? 3
                : 4;
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: rewards.length,
          itemBuilder: (context, i) => RewardCard(
            reward: rewards[i],
            totalXp: totalXp,
            onDelete: () => onDelete(rewards[i].id),
          ),
        );
      },
    );
  }
}

// ── Badges tab ────────────────────────────────────────────────────────────────

class _BadgesTab extends StatelessWidget {
  const _BadgesTab({required this.achievements});

  final List<Achievement> achievements;

  @override
  Widget build(BuildContext context) {
    final unlocked = achievements.where((a) => a.isUnlocked).toList();
    final locked = achievements.where((a) => !a.isUnlocked).toList();
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (unlocked.isNotEmpty) ...[
          Text(
            'EARNED',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.success,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          ...unlocked.map((a) => AchievementBadge(achievement: a)),
          const SizedBox(height: 16),
        ],
        Text(
          'LOCKED',
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.onSurface,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        ...locked.map((a) => AchievementBadge(achievement: a)),
      ],
    );
  }
}
