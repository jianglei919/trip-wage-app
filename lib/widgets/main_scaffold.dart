import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  static const _paths = [
    '/dashboard',
    '/trips',
    '/stats',
    '/profile',
  ];
  static const _icons = [
    Icons.dashboard_outlined,
    Icons.list_alt_outlined,
    Icons.bar_chart_outlined,
    Icons.settings_outlined,
  ];
  static const _selectedIcons = [
    Icons.dashboard,
    Icons.list_alt,
    Icons.bar_chart,
    Icons.settings,
  ];

  int get _currentIndex {
    final i = _paths.indexWhere((p) => location.startsWith(p));
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppL10n.of(context)!;
    final labels = [
      t.navDashboard,
      t.navTrips,
      t.navStats,
      t.navProfile,
    ];
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => context.go(_paths[i]),
        indicatorColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        destinations: [
          for (var i = 0; i < _paths.length; i++)
            NavigationDestination(
              icon: Icon(_icons[i], color: scheme.onSurfaceVariant),
              selectedIcon: Icon(_selectedIcons[i], color: scheme.primary),
              label: labels[i],
            ),
        ],
      ),
    );
  }
}
