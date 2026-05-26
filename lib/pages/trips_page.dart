import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/calc/order_calc.dart';
import '../core/date_utils.dart';
import '../core/db/database.dart';
import '../l10n/generated/app_localizations.dart';
import '../providers/providers.dart';

/// 0 = 全部，>0 = 最近 N 天
final _rangeDaysProvider = StateProvider<int>((_) => 30);

final _rangeOrdersProvider =
    StreamProvider.autoDispose.family<List<Order>, int>((ref, days) {
  final repo = ref.watch(orderRepositoryProvider);
  if (days <= 0) return repo.watchAll();
  final end = todayString();
  final start = addDays(end, -(days - 1));
  return repo.watchByDateRange(start, end);
});

class TripsPage extends ConsumerWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppL10n.of(context)!;
    final days = ref.watch(_rangeDaysProvider);
    final ordersAsync = ref.watch(_rangeOrdersProvider(days));
    final settingsAsync = ref.watch(settingsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.navTrips),
        actions: [
          PopupMenuButton<int>(
            initialValue: days,
            icon: const Icon(Icons.filter_list),
            tooltip: t.navTrips,
            onSelected: (v) =>
                ref.read(_rangeDaysProvider.notifier).state = v,
            itemBuilder: (_) => [
              PopupMenuItem(value: 7, child: Text(t.tripsFilterLast7)),
              PopupMenuItem(value: 14, child: Text(t.tripsFilterLast14)),
              PopupMenuItem(value: 30, child: Text(t.tripsFilterLast30)),
              PopupMenuItem(value: 90, child: Text(t.tripsFilterLast90)),
              const PopupMenuDivider(),
              PopupMenuItem(value: 0, child: Text(t.tripsFilterAll)),
            ],
          ),
        ],
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (settings) {
          final params = WageParams.fromSettings(settings);
          final orders = ordersAsync.valueOrNull ?? const <Order>[];
          if (orders.isEmpty) {
            return Center(
              child: Text(t.dashboardEmpty,
                  style: TextStyle(color: Colors.grey.shade600)),
            );
          }
          // 按日期分组（降序）
          final grouped = groupBy(orders, (Order o) => o.date);
          final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: dates.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final date = dates[i];
              final dayOrders = grouped[date]!;
              return _DayCard(
                date: date,
                orders: dayOrders,
                params: params,
                onTap: () {
                  ref.read(currentDateProvider.notifier).state = date;
                  context.go('/dashboard');
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.date,
    required this.orders,
    required this.params,
    required this.onTap,
  });
  final String date;
  final List<Order> orders;
  final WageParams params;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppL10n.of(context)!;
    final summary = calcDailySummary(
      orders: orders,
      workHours: 0,
      params: params,
    );
    final income = summary.fuelFeeTotal + summary.totalTips;
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: scheme.primaryContainer,
                child: Text(date.substring(8),
                    style: TextStyle(color: scheme.onPrimaryContainer)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      '${summary.actualTrips} ${t.dashboardOrders}'
                      ' · ${summary.totalDistance.toStringAsFixed(1)} ${t.commonKm}'
                      ' · ${t.dashboardTips} \$${summary.totalTips.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Text('\$${income.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
