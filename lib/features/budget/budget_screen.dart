import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuanquest/core/core.dart';

import 'package:cuanquest/domain/domain.dart';
import 'package:cuanquest/features/budget/providers/budget_categories_provider.dart';
import 'package:cuanquest/features/budget/providers/budget_posts_provider.dart';
import 'package:cuanquest/features/budget/widgets/add_category_sheet.dart';
import 'package:cuanquest/features/budget/widgets/add_post_sheet.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(filteredBudgetCategoriesProvider);
    final posts = ref.watch(filteredBudgetPostsProvider);
    final totalBudget = ref.watch(totalBudgetProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: MonthNavigator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddCategorySheet(context),
        backgroundColor: AppColors.primary,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: categories.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('💰', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 16),
                  Text('No budget set', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first budget category',
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              children: [
                // Total summary
                GameCard(
                  shadowColor: AppColors.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TOTAL BUDGET',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurface,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        'Rp ${_fmt(totalBudget)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Category cards
                ...categories.map((cat) {
                  final catPosts =
                      posts.where((p) => p.categoryId == cat.id).toList();
                  final catTotal =
                      catPosts.fold(0.0, (s, p) => s + p.amount);

                  return _CategoryCard(
                    category: cat,
                    posts: catPosts,
                    total: catTotal,
                    onAddPost: () =>
                        _openAddPostSheet(context, cat.id),
                    onDeleteCategory: () => ref
                        .read(budgetCategoriesProvider.notifier)
                        .remove(cat.id),
                    onDeletePost: (id) =>
                        ref.read(budgetPostsProvider.notifier).remove(id),
                  );
                }),
              ],
            ),
    );
  }

  void _openAddCategorySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (_) => const AddCategorySheet(),
    );
  }

  void _openAddPostSheet(BuildContext context, String categoryId) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (_) => AddPostSheet(categoryId: categoryId),
    );
  }

  static String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}

// ── Category card ─────────────────────────────────────────────────────────────

class _CategoryCard extends StatefulWidget {
  const _CategoryCard({
    required this.category,
    required this.posts,
    required this.total,
    required this.onAddPost,
    required this.onDeleteCategory,
    required this.onDeletePost,
  });

  final BudgetCategory category;
  final List<BudgetPost> posts;
  final double total;
  final VoidCallback onAddPost;
  final VoidCallback onDeleteCategory;
  final void Function(String id) onDeletePost;

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GameCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Header row
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
              child: Row(
                children: [
                  Text(
                    widget.category.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category.name,
                          style: theme.textTheme.titleSmall,
                        ),
                        Text(
                          'Rp ${_fmt(widget.total)}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_rounded, size: 18),
                    color: AppColors.primary,
                    onPressed: widget.onAddPost,
                    tooltip: 'Add post',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    color: AppColors.borderMuted,
                    onPressed: widget.onDeleteCategory,
                    tooltip: 'Delete category',
                  ),
                  Icon(
                    _expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: AppColors.borderMuted,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          // Posts
          if (_expanded && widget.posts.isNotEmpty) ...[
            const Divider(height: 1, color: AppColors.borderMuted),
            ...widget.posts.map(
              (p) => _PostRow(
                post: p,
                onDelete: () => widget.onDeletePost(p.id),
              ),
            ),
          ],

          if (_expanded && widget.posts.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Text(
                'No posts yet — tap + to add one',
                style: theme.textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }

  static String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}

class _PostRow extends StatelessWidget {
  const _PostRow({required this.post, required this.onDelete});

  final BudgetPost post;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = post.type == BudgetPostType.fixed
        ? AppColors.tertiary
        : AppColors.secondary;
    final typeLabel =
        post.type == BudgetPostType.fixed ? 'FIXED' : 'MAX';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderMuted)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 34), // indent under emoji
          Expanded(
            child: Text(post.name, style: theme.textTheme.bodyMedium),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.15),
              border: Border.all(color: typeColor),
            ),
            child: Text(
              typeLabel,
              style: TextStyle(
                color: typeColor,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Rp ${_fmt(post.amount)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.close_rounded,
              size: 16,
              color: AppColors.borderMuted,
            ),
          ),
        ],
      ),
    );
  }

  static String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}
