import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

/// Helper: format DateTime as 'MM-YYYY'
String monthYearKey(DateTime dt) =>
    '${dt.month.toString().padLeft(2, '0')}-${dt.year}';
