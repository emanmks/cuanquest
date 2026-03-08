import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuanquest/core/core.dart';
import 'package:cuanquest/domain/domain.dart';
import 'package:cuanquest/features/budget/providers/budget_categories_provider.dart';
import 'package:cuanquest/features/budget/providers/budget_posts_provider.dart';

/// Distinct colors for pie chart sections
const _sectionColors = [
  Color(0xFF6C63FF),
  Color(0xFFFF6B6B),
  Color(0xFF4ECDC4),
  Color(0xFFFFE66D),
  Color(0xFF95E1D3),
  Color(0xFFF38181),
  Color(0xFFA8E6CF),
  Color(0xFFFFAA85),
];

class BudgetPieChart extends ConsumerWidget {
  const BudgetPieChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(filteredBudgetCategoriesProvider);
    final posts = ref.watch(filteredBudgetPostsProvider);
    final theme = Theme.of(context);

    if (categories.isEmpty || posts.isEmpty) {
      return GameCard(
        shadowColor: AppColors.borderMuted,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BUDGET ALLOCATION',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.onSurface,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'No budget set — tap EDIT BUDGET to get started',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    // Build per-category total amounts
    final data = <_ChartData>[];
    for (var i = 0; i < categories.length; i++) {
      final cat = categories[i];
      final catPosts = posts.where((p) => p.categoryId == cat.id);
      final total = catPosts.fold(0.0, (s, p) => s + p.amount);
      if (total > 0) {
        data.add(_ChartData(
          category: cat,
          amount: total,
          color: _sectionColors[i % _sectionColors.length],
        ));
      }
    }

    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    final grandTotal = data.fold(0.0, (s, d) => s + d.amount);

    return GameCard(
      shadowColor: AppColors.borderMuted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BUDGET ALLOCATION',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.onSurface,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: data
                          .map(
                            (d) => PieChartSectionData(
                              value: d.amount,
                              color: d.color,
                              radius: 55,
                              title: '',
                            ),
                          )
                          .toList(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Legend
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data
                        .map(
                          (d) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  color: d.color,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '${d.category.emoji} ${d.category.name}',
                                    style: theme.textTheme.labelSmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total: Rp ${_fmt(grandTotal)}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
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

class _ChartData {
  const _ChartData({
    required this.category,
    required this.amount,
    required this.color,
  });

  final BudgetCategory category;
  final double amount;
  final Color color;
}
