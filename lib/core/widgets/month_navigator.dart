import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuanquest/core/providers/selected_month_provider.dart';
import 'package:cuanquest/core/theme/app_colors.dart';

class MonthNavigator extends ConsumerWidget {
  const MonthNavigator({super.key});

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedMonthProvider);
    final now = DateTime.now();
    final isCurrentMonth =
        selected.year == now.year && selected.month == now.month;

    final label = '${_months[selected.month - 1]} ${selected.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            color: AppColors.onSurface,
            onPressed: () {
              final prev = DateTime(selected.year, selected.month - 1, 1);
              ref.read(selectedMonthProvider.notifier).state = prev;
            },
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.onBackground,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            color: isCurrentMonth ? AppColors.borderMuted : AppColors.onSurface,
            onPressed: isCurrentMonth
                ? null
                : () {
                    final next =
                        DateTime(selected.year, selected.month + 1, 1);
                    ref.read(selectedMonthProvider.notifier).state = next;
                  },
          ),
        ],
      ),
    );
  }
}
