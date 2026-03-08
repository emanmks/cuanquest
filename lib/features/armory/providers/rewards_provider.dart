import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:cuanquest/domain/domain.dart';

const _uuid = Uuid();

class RewardsNotifier extends Notifier<List<Reward>> {
  @override
  List<Reward> build() => _seed();

  void add({
    required String name,
    required int xpCost,
    required String emoji,
  }) {
    state = [
      ...state,
      Reward(id: _uuid.v4(), name: name, xpCost: xpCost, imagePath: emoji),
    ];
  }

  void remove(String id) {
    state = state.where((r) => r.id != id).toList();
  }

  static List<Reward> _seed() => [
        Reward(id: _uuid.v4(), name: 'New Sneakers', xpCost: 50, imagePath: '👟'),
        Reward(id: _uuid.v4(), name: 'Gaming Setup', xpCost: 150, imagePath: '🎮'),
        Reward(id: _uuid.v4(), name: 'Weekend Trip', xpCost: 450, imagePath: '✈️'),
        Reward(id: _uuid.v4(), name: 'New Laptop', xpCost: 750, imagePath: '💻'),
      ];
}

final rewardsProvider = NotifierProvider<RewardsNotifier, List<Reward>>(
  RewardsNotifier.new,
);
