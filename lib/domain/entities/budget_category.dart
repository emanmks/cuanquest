class BudgetCategory {
  const BudgetCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.monthYear,
  });

  final String id;
  final String name;
  final String emoji;
  final String monthYear; // 'MM-YYYY'

  BudgetCategory copyWith({
    String? name,
    String? emoji,
    String? monthYear,
  }) {
    return BudgetCategory(
      id: id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      monthYear: monthYear ?? this.monthYear,
    );
  }
}
