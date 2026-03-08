import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:cuanquest/core/providers/selected_month_provider.dart';
import 'package:cuanquest/domain/domain.dart';

const _uuid = Uuid();

class BudgetPostsNotifier extends Notifier<List<BudgetPost>> {
  @override
  List<BudgetPost> build() => [];

  void add({
    required String categoryId,
    required String name,
    required BudgetPostType type,
    required double amount,
  }) {
    final month = ref.read(selectedMonthProvider);
    final key = monthYearKey(month);
    state = [
      ...state,
      BudgetPost(
        id: _uuid.v4(),
        categoryId: categoryId,
        name: name,
        type: type,
        amount: amount,
        monthYear: key,
      ),
    ];
  }

  void remove(String id) {
    state = state.where((p) => p.id != id).toList();
  }
}

final budgetPostsProvider =
    NotifierProvider<BudgetPostsNotifier, List<BudgetPost>>(
  BudgetPostsNotifier.new,
);

/// Derived: posts for selected month
final filteredBudgetPostsProvider = Provider<List<BudgetPost>>((ref) {
  final all = ref.watch(budgetPostsProvider);
  final month = ref.watch(selectedMonthProvider);
  final key = monthYearKey(month);
  return all.where((p) => p.monthYear == key).toList();
});

/// Derived: total budgeted amount for selected month
final totalBudgetProvider = Provider<double>((ref) {
  final posts = ref.watch(filteredBudgetPostsProvider);
  return posts.fold(0.0, (sum, p) => sum + p.amount);
});
