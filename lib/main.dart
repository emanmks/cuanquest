import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
