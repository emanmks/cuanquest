import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuanquest/core/core.dart';

import 'package:cuanquest/domain/domain.dart';
import 'package:cuanquest/features/ledger/providers/transactions_provider.dart';
import 'package:cuanquest/features/ledger/widgets/add_transaction_sheet.dart';
import 'package:cuanquest/features/ledger/widgets/transaction_tile.dart';

class LedgerScreen extends ConsumerWidget {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(filteredTransactionsProvider);
    final theme = Theme.of(context);

    final grouped = <DateTime, List<Transaction>>{};
    for (final t in transactions) {
      final date =
          DateTime(t.createdAt.year, t.createdAt.month, t.createdAt.day);
      grouped.putIfAbsent(date, () => []).add(t);
    }
    final sortedDates = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              '${transactions.length} entries',
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: AppColors.onSurface),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: MonthNavigator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddSheet(context),
        backgroundColor: AppColors.primary,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.receipt_long_rounded,
                    size: 64,
                    color: AppColors.borderMuted,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to log your first transaction',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: sortedDates.length,
              itemBuilder: (context, i) {
                final date = sortedDates[i];
                final dayTxns = grouped[date]!;
                final dayNet = dayTxns.fold(0.0, (sum, t) {
                  return t.type == TransactionType.expense
                      ? sum - t.amount
                      : sum + t.amount;
                });

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DateHeader(date: date, netTotal: dayNet),
                    const SizedBox(height: 8),
                    ...dayTxns.map(
                      (t) => Dismissible(
                        key: ValueKey(t.id),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) => _confirmDelete(context),
                        onDismissed: (_) {
                          ref.read(transactionsProvider.notifier).remove(t.id);
                        },
                        background: Container(
                          color: AppColors.error,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete_rounded,
                            color: Colors.white,
                          ),
                        ),
                        child: TransactionTile(
                          transaction: t,
                          onTap: () => _openEditSheet(context, t),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
    );
  }

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => const AddTransactionSheet(),
    );
  }

  void _openEditSheet(BuildContext context, Transaction t) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => AddTransactionSheet(initialTransaction: t),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text('Delete transaction?'),
            content: const Text('This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
                child: const Text('DELETE'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date, required this.netTotal});

  final DateTime date;
  final double netTotal;

  String get _label {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    if (date == today) return 'Today';
    if (date == yesterday) return 'Yesterday';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final positive = netTotal >= 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            _label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.onSurface,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          Text(
            '${positive ? '+' : '−'} Rp ${_formatAmount(netTotal.abs())}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: positive ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
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
