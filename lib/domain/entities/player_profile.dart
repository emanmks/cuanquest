class PlayerProfile {
  const PlayerProfile({
    required this.id,
    required this.totalXp,
    required this.hp,
    required this.streakCount,
    required this.lastLogDate,
    required this.lastActiveMonth,
  });

  final String id;
  final int totalXp; // cumulative; level is derived from this
  final int hp; // 0–100
  final int streakCount;
  final DateTime lastLogDate;
  final String lastActiveMonth; // 'MM-YYYY' for monthly HP reset tracking

  PlayerProfile copyWith({
    int? totalXp,
    int? hp,
    int? streakCount,
    DateTime? lastLogDate,
    String? lastActiveMonth,
  }) {
    return PlayerProfile(
      id: id,
      totalXp: totalXp ?? this.totalXp,
      hp: hp ?? this.hp,
      streakCount: streakCount ?? this.streakCount,
      lastLogDate: lastLogDate ?? this.lastLogDate,
      lastActiveMonth: lastActiveMonth ?? this.lastActiveMonth,
    );
  }
}
