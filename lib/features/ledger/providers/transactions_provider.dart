import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:cuanquest/core/providers/selected_month_provider.dart';
import 'package:cuanquest/domain/domain.dart';

const _uuid = Uuid();

class TransactionsNotifier extends Notifier<List<Transaction>> {
  @override
  List<Transaction> build() => _seed();

  Transaction add({
    required double amount,
    required TransactionCategory category,
    required TransactionType type,
    required bool isEssential,
    required String note,
  }) {
    final transaction = Transaction(
      id: _uuid.v4(),
      amount: amount,
      category: category,
      type: type,
      isEssential: isEssential,
      note: note,
      createdAt: DateTime.now(),
    );
    state = [transaction, ...state];
    return transaction;
  }

  void update(Transaction updated) {
    state = [
      for (final t in state)
        if (t.id == updated.id) updated else t,
    ];
  }

  void remove(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  static List<Transaction> _seed() {
    final now = DateTime.now();
    return [
      Transaction(
        id: _uuid.v4(),
        amount: 50000,
        category: TransactionCategory.food,
        type: TransactionType.expense,
        isEssential: true,
        note: 'Lunch at warung',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      Transaction(
        id: _uuid.v4(),
        amount: 15000,
        category: TransactionCategory.transport,
        type: TransactionType.expense,
        isEssential: true,
        note: 'Gojek',
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      Transaction(
        id: _uuid.v4(),
        amount: 200000,
        category: TransactionCategory.shopping,
        type: TransactionType.expense,
        isEssential: false,
        note: 'New shirt',
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
      ),
      Transaction(
        id: _uuid.v4(),
        amount: 35000,
        category: TransactionCategory.food,
        type: TransactionType.expense,
        isEssential: true,
        note: 'Dinner',
        createdAt: now.subtract(const Duration(days: 1, hours: 6)),
      ),
      Transaction(
        id: _uuid.v4(),
        amount: 5000000,
        category: TransactionCategory.salary,
        type: TransactionType.income,
        isEssential: true,
        note: 'Monthly salary',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }
}

final transactionsProvider =
    NotifierProvider<TransactionsNotifier, List<Transaction>>(
  TransactionsNotifier.new,
);

/// Derived provider: transactions filtered to selected month
final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  final all = ref.watch(transactionsProvider);
  final month = ref.watch(selectedMonthProvider);
  final key = monthYearKey(month);
  return all.where((t) {
    final tKey = monthYearKey(
      DateTime(t.createdAt.year, t.createdAt.month),
    );
    return tKey == key;
  }).toList();
});
