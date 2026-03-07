import 'package:flutter/material.dart';
import 'package:cuanquest/core/core.dart';
import 'package:cuanquest/domain/domain.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExpense = transaction.type == TransactionType.expense;
    final amountColor = isExpense ? AppColors.error : AppColors.success;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          left: BorderSide(color: transaction.category.color, width: 4),
          top: const BorderSide(color: AppColors.borderMuted),
          right: const BorderSide(color: AppColors.borderMuted),
          bottom: const BorderSide(color: AppColors.borderMuted),
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          color: transaction.category.color.withValues(alpha: 0.15),
          child: Icon(
            transaction.category.icon,
            color: transaction.category.color,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Text(
              transaction.category.displayName,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(width: 6),
            _Badge(
              label: isExpense
                  ? (transaction.isEssential ? 'Essential' : 'Want')
                  : 'Income',
              color: isExpense
                  ? (transaction.isEssential
                      ? AppColors.secondary
                      : AppColors.primary)
                  : AppColors.success,
            ),
          ],
        ),
        subtitle: transaction.note.isNotEmpty
            ? Text(
                transaction.note,
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Text(
          '${isExpense ? '−' : '+'} Rp ${_formatAmount(transaction.amount)}',
          style: theme.textTheme.titleSmall?.copyWith(
            color: amountColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  static String _formatAmount(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
