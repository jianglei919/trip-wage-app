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
        // 选中项：图标底下一块主题色胶囊 + 标签主题色加粗，一眼能看出当前在哪
        indicatorColor: scheme.primaryContainer,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
        destinations: [
          for (var i = 0; i < _paths.length; i++)
            NavigationDestination(
              icon: Icon(_icons[i], color: scheme.onSurfaceVariant),
              selectedIcon: Icon(_selectedIcons[i],
                  color: scheme.onPrimaryContainer),
              label: labels[i],
            ),
        ],
      ),
    );
  }
}
