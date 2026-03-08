enum BudgetPostType { fixed, max }

class BudgetPost {
  const BudgetPost({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.type,
    required this.amount,
    required this.monthYear,
  });

  final String id;
  final String categoryId;
  final String name;
  final BudgetPostType type;
  final double amount;
  final String monthYear; // 'MM-YYYY'

  BudgetPost copyWith({
    String? categoryId,
    String? name,
    BudgetPostType? type,
    double? amount,
    String? monthYear,
  }) {
    return BudgetPost(
      id: id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      monthYear: monthYear ?? this.monthYear,
    );
  }
}
