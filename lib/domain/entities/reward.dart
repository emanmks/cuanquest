class Reward {
  const Reward({
    required this.id,
    required this.name,
    required this.xpCost,
    required this.isUnlocked,
    required this.imagePath,
  });

  final String id;
  final String name;
  final int xpCost;
  final bool isUnlocked;
  final String imagePath;
}
