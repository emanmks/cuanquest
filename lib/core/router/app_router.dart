import 'package:go_router/go_router.dart';
import 'package:cuanquest/core/shell/app_shell.dart';
import 'package:cuanquest/features/dashboard/dashboard_screen.dart';
import 'package:cuanquest/features/ledger/ledger_screen.dart';
import 'package:cuanquest/features/armory/armory_screen.dart';
import 'package:cuanquest/features/profile/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/ledger',
          builder: (context, state) => const LedgerScreen(),
        ),
        GoRoute(
          path: '/armory',
          builder: (context, state) => const ArmoryScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
