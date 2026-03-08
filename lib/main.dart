import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:cuanquest/core/core.dart';
import 'package:cuanquest/core/providers/database_provider.dart';
import 'package:cuanquest/data/database/app_database.dart';

void main() {
  final db = AppDatabase(
    driftDatabase(
      name: 'cuanquest',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    ),
  );

  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const CuanQuestApp(),
    ),
  );
}

class CuanQuestApp extends StatelessWidget {
  const CuanQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CuanQuest',
      theme: AppTheme.dark,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: const [
          Breakpoint(start: 0, end: 599, name: MOBILE),
          Breakpoint(start: 600, end: 1199, name: TABLET),
          Breakpoint(start: 1200, end: double.infinity, name: DESKTOP),
        ],
      ),
    );
  }
}
