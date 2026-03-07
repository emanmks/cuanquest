import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _paths = ['/', '/ledger', '/armory', '/profile'];

  static const _destinations = [
    (label: 'Dashboard', icon: Icons.home_outlined, selectedIcon: Icons.home_rounded),
    (label: 'Ledger', icon: Icons.receipt_long_outlined, selectedIcon: Icons.receipt_long_rounded),
    (label: 'Armory', icon: Icons.shield_outlined, selectedIcon: Icons.shield_rounded),
    (label: 'Profile', icon: Icons.person_outline_rounded, selectedIcon: Icons.person_rounded),
  ];

  int _selectedIndex(String location) {
    if (location.startsWith('/ledger')) return 1;
    if (location.startsWith('/armory')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _selectedIndex(location);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    if (isMobile) {
      return Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (i) => context.go(_paths[i]),
          destinations: _destinations
              .map(
                (d) => NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                ),
              )
              .toList(),
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) => context.go(_paths[i]),
            labelType: NavigationRailLabelType.all,
            destinations: _destinations
                .map(
                  (d) => NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
