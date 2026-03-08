class Achievement {
  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.isUnlocked,
  });

  final String id;
  final String name;
  final String description;
  final String emoji;
  final bool isUnlocked;
}
