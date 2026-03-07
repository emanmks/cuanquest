class Quest {
  const Quest({
    required this.id,
    required this.monthlyLimit,
    required this.currentSpending,
    required this.monthYear,
  });

  final String id;
  final double monthlyLimit;
  final double currentSpending;
  final String monthYear; // MM-YYYY
}
