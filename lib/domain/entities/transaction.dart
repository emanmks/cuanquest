enum TransactionType { income, expense }

class Transaction {
  const Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.type,
    required this.isEssential,
    required this.note,
    required this.createdAt,
  });

  final String id;
  final double amount;
  final String category;
  final TransactionType type;
  final bool isEssential; // true = neutral, false = mana drain
  final String note;
  final DateTime createdAt;
}
