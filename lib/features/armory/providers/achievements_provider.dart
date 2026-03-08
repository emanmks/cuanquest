import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuanquest/core/services/achievement_service.dart';
import 'package:cuanquest/domain/domain.dart';
import 'package:cuanquest/features/ledger/providers/transactions_provider.dart';
import 'package:cuanquest/features/profile/providers/player_profile_provider.dart';

/// Derived provider — recomputes badges whenever profile or transactions change.
final achievementsProvider = Provider<List<Achievement>>((ref) {
  final profile = ref.watch(playerProfileProvider);
  final transactions = ref.watch(transactionsProvider);
  return AchievementService.compute(profile, transactions);
});
