class Reward {
  const Reward({
    required this.id,
    required this.name,
    required this.xpCost,
    required this.imagePath,
  });

  final String id;
  final String name;
  final int xpCost;
  final String imagePath; // emoji string used as visual placeholder

  /// Unlock condition: player must have accumulated at least [xpCost] total XP.
  bool isUnlocked(int totalXp) => totalXp >= xpCost;

  int xpNeeded(int totalXp) => (xpCost - totalXp).clamp(0, xpCost);
}
