class PlayerProfile {
  const PlayerProfile({
    required this.id,
    required this.level,
    required this.currentXp,
    required this.hp,
    required this.streakCount,
    required this.lastLogDate,
  });

  final String id;
  final int level;
  final int currentXp;
  final int hp; // 0-100
  final int streakCount;
  final DateTime lastLogDate;
}
