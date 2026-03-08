import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:cuanquest/core/providers/selected_month_provider.dart';
import 'package:cuanquest/domain/domain.dart';

const _uuid = Uuid();

class BudgetCategoriesNotifier extends Notifier<List<BudgetCategory>> {
  @override
  List<BudgetCategory> build() => [];

  void add({required String name, required String emoji}) {
    final month = ref.read(selectedMonthProvider);
    final key = monthYearKey(month);
    state = [
      ...state,
      BudgetCategory(id: _uuid.v4(), name: name, emoji: emoji, monthYear: key),
    ];
  }

  void remove(String id) {
    state = state.where((c) => c.id != id).toList();
  }
}

final budgetCategoriesProvider =
    NotifierProvider<BudgetCategoriesNotifier, List<BudgetCategory>>(
  BudgetCategoriesNotifier.new,
);

/// Derived: categories for selected month
final filteredBudgetCategoriesProvider = Provider<List<BudgetCategory>>((ref) {
  final all = ref.watch(budgetCategoriesProvider);
  final month = ref.watch(selectedMonthProvider);
  final key = monthYearKey(month);
  return all.where((c) => c.monthYear == key).toList();
});
