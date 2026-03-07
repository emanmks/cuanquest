import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuanquest/core/core.dart';

void main() {
  runApp(const ProviderScope(child: CuanQuestApp()));
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
    );
  }
}
