import 'package:go_router/go_router.dart';

import '../pages/dashboard_page.dart';
import '../pages/profile_page.dart';
import '../pages/stats_page.dart';
import '../pages/trips_page.dart';
import '../widgets/main_scaffold.dart';

final appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          MainScaffold(location: state.matchedLocation, child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (_, __) => const DashboardPage(),
        ),
        GoRoute(
          path: '/trips',
          builder: (_, __) => const TripsPage(),
        ),
        GoRoute(
          path: '/stats',
          builder: (_, __) => const StatsPage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (_, __) => const ProfilePage(),
        ),
      ],
    ),
  ],
);
