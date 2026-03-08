import 'package:flutter/material.dart';

enum TransactionType { income, expense }

enum TransactionCategory {
  // Expense categories
  food,
  transport,
  shopping,
  entertainment,
  health,
  bills,
  education,
  // Income categories
  salary,
  freelance,
  gift,
  // Universal
  other;

  String get displayName => switch (this) {
        food => 'Food',
        transport => 'Transport',
        shopping => 'Shopping',
        entertainment => 'Entertainment',
        health => 'Health',
        bills => 'Bills',
        education => 'Education',
        salary => 'Salary',
        freelance => 'Freelance',
        gift => 'Gift',
        other => 'Other',
      };

  IconData get icon => switch (this) {
        food => Icons.restaurant_rounded,
        transport => Icons.directions_car_rounded,
        shopping => Icons.shopping_bag_rounded,
        entertainment => Icons.sports_esports_rounded,
        health => Icons.favorite_rounded,
        bills => Icons.receipt_long_rounded,
        education => Icons.school_rounded,
        salary => Icons.work_rounded,
        freelance => Icons.laptop_rounded,
        gift => Icons.card_giftcard_rounded,
        other => Icons.category_rounded,
      };

  Color get color => switch (this) {
        food => const Color(0xFFFF6B35),
        transport => const Color(0xFF4ECDC4),
        shopping => const Color(0xFFFFB347),
        entertainment => const Color(0xFF9B59B6),
        health => const Color(0xFFE74C3C),
        bills => const Color(0xFF3498DB),
        education => const Color(0xFF27AE60),
        salary => const Color(0xFF2ECC71),
        freelance => const Color(0xFF1ABC9C),
        gift => const Color(0xFFE91E63),
        other => const Color(0xFF95A5A6),
      };

  static List<TransactionCategory> get expenseCategories => [
        food,
        transport,
        shopping,
        entertainment,
        health,
        bills,
        education,
        other,
      ];

  static List<TransactionCategory> get incomeCategories => [
        salary,
        freelance,
        gift,
        other,
      ];
}

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
  final TransactionCategory category;
  final TransactionType type;
  final bool isEssential; // true = neutral, false = mana drain
  final String note;
  final DateTime createdAt;

  Transaction copyWith({
    double? amount,
    TransactionCategory? category,
    TransactionType? type,
    bool? isEssential,
    String? note,
    DateTime? createdAt,
  }) {
    return Transaction(
      id: id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      isEssential: isEssential ?? this.isEssential,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
