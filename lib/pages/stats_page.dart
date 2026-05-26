import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/calc/order_calc.dart';
import '../core/date_utils.dart';
import '../core/db/database.dart';
import '../core/excel_export.dart';
import '../core/theme/accents.dart';
import '../l10n/generated/app_localizations.dart';
import '../providers/providers.dart';
import 'leaderboard_page.dart';

class _Range {
  const _Range(this.start, this.end);
  final String start;
  final String end;
}

/// 用 family 让 settings 变化时（锚点/周期天数）也能重算默认值
final _rangeProvider =
    StateProvider.family<_Range, AppSetting>((ref, settings) {
  final cycle = biweeklyCycleOf(
    date: todayString(),
    anchorDate: settings.biweeklyAnchorDate,
    cycleDays: settings.biweeklySettlementDays,
  );
  return _Range(cycle.start, cycle.end);
});

final _rangeOrdersProvider =
    StreamProvider.autoDispose.family<List<Order>, _Range>(
  (ref, r) =>
      ref.watch(orderRepositoryProvider).watchByDateRange(r.start, r.end),
);

final _rangeWorkTimesProvider =
    StreamProvider.autoDispose.family<List<WorkTime>, _Range>(
  (ref, r) =>
      ref.watch(workTimeRepositoryProvider).watchByDateRange(r.start, r.end),
);

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppL10n.of(context)!;
    final settingsAsync = ref.watch(settingsStreamProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.navStats),
          bottom: TabBar(
            tabs: [
              Tab(text: t.navStats),
              Tab(text: t.navLeaderboard),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            settingsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (settings) => _StatsBody(settings: settings),
            ),
            const LeaderboardView(),
          ],
        ),
      ),
    );
  }
}

class _StatsBody extends ConsumerWidget {
  const _StatsBody({required this.settings});
  final AppSetting settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppL10n.of(context)!;
    final range = ref.watch(_rangeProvider(settings));
    final ordersAsync = ref.watch(_rangeOrdersProvider(range));
    final workTimesAsync = ref.watch(_rangeWorkTimesProvider(range));
    final params = WageParams.fromSettings(settings);

    final orders = ordersAsync.valueOrNull ?? const <Order>[];
    final workTimes = workTimesAsync.valueOrNull ?? const <WorkTime>[];

    // 按日期聚合
    final ordersByDate = groupBy(orders, (Order o) => o.date);
    final workHoursByDate = {
      for (final w in workTimes) w.date: w.workHours,
    };
    final allDates = _dateSeq(range.start, range.end);

    final daily = <_DailyStat>[];
    for (final d in allDates) {
      final dayOrders = ordersByDate[d] ?? const <Order>[];
      final hours = workHoursByDate[d] ?? 0.0;
      final s = calcDailySummary(
        orders: dayOrders,
        workHours: hours,
        params: params,
      );
      daily.add(_DailyStat(
        date: d,
        workHours: hours,
        summary: s,
      ));
    }

    // 区间汇总
    int workingDays = 0;
    int totalTrips = 0;
    int totalLongTrips = 0;
    double totalDistance = 0;
    double totalTips = 0;
    double totalFuel = 0;
    double totalWorkHours = 0;
    double totalBasePay = 0;
    for (final d in daily) {
      if (d.summary.actualTrips > 0) workingDays++;
      totalTrips += d.summary.actualTrips;
      totalLongTrips += d.summary.longTrips;
      totalDistance += d.summary.totalDistance;
      totalTips += d.summary.totalTips;
      totalFuel += d.summary.fuelFeeTotal;
      totalWorkHours += d.workHours;
      totalBasePay += d.summary.basePayment;
    }
    final totalWage = totalBasePay + totalFuel + totalTips;
    final avgHourly = totalWorkHours > 0 ? totalWage / totalWorkHours : 0.0;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _CycleNavCard(settings: settings, range: range),
        const SizedBox(height: 12),

        // 总收入大卡
        _BigTotalCard(
          totalWage: totalWage,
          basePay: totalBasePay,
          fuel: totalFuel,
          tips: totalTips,
        ),
        const SizedBox(height: 12),

        // 指标卡 2x3 grid，每张不同色调
        _MetricsGrid(items: [
          _MetricItem(t.statsWorkingDays, '$workingDays ${t.statsDays}',
              Icons.event_available, AppAccents.blue),
          _MetricItem(
              t.statsTotalOrders,
              totalLongTrips > 0 ? '$totalTrips+$totalLongTrips' : '$totalTrips',
              Icons.inventory_2_outlined,
              AppAccents.purple),
          _MetricItem(
              t.statsTotalWorkHours,
              '${totalWorkHours.toStringAsFixed(1)}${t.commonHours}',
              Icons.timer_outlined,
              AppAccents.orange),
          _MetricItem(
              t.dashboardDistance,
              '${totalDistance.toStringAsFixed(0)}${t.commonKm}',
              Icons.directions_car_outlined,
              AppAccents.teal),
          _MetricItem(t.statsAvgHourly, '\$${avgHourly.toStringAsFixed(2)}',
              Icons.trending_up, AppAccents.green),
          _MetricItem(
              t.statsBiweeklyPay,
              '\$${(totalBasePay + totalFuel).toStringAsFixed(2)}',
              Icons.account_balance_wallet_outlined,
              AppAccents.pink),
        ]),
        const SizedBox(height: 16),

        // 堆叠柱状图：每日 base / tips / fuel
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(t.statsDailyBreakdown,
              style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(height: 8),
        _StackedBarChart(daily: daily),
        const SizedBox(height: 16),

        // 饼图：收入构成
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(t.statsComposition,
              style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(height: 8),
        _CompositionPie(
            basePay: totalBasePay, tips: totalTips, fuel: totalFuel),
        const SizedBox(height: 16),

        // 导出
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            icon: const Icon(Icons.ios_share),
            label: const Text('Export Excel'),
            onPressed: orders.isEmpty
                ? null
                : () async {
                    await exportOrdersToExcel(
                      orders: orders,
                      params: params,
                      filenameStem:
                          'tripwage-${range.start}_${range.end}',
                    );
                  },
          ),
        ),
        const SizedBox(height: 24),

        if (orders.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(t.statsNoData,
                  style: TextStyle(color: Colors.grey.shade600)),
            ),
          ),
      ],
    );
  }

  List<String> _dateSeq(String start, String end) {
    final out = <String>[];
    var cur = start;
    while (cur.compareTo(end) <= 0) {
      out.add(cur);
      cur = addDays(cur, 1);
    }
    return out;
  }
}

class _DailyStat {
  const _DailyStat({
    required this.date,
    required this.workHours,
    required this.summary,
  });
  final String date;
  final double workHours;
  final DailySummary summary;
}

class _CycleNavCard extends ConsumerWidget {
  const _CycleNavCard({required this.settings, required this.range});
  final AppSetting settings;
  final _Range range;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppL10n.of(context)!;
    final cycleDays = settings.biweeklySettlementDays;
    final offset = biweeklyCycleOffset(
      start: range.start,
      end: range.end,
      anchorDate: settings.biweeklyAnchorDate,
      cycleDays: cycleDays,
    );
    final scheme = Theme.of(context).colorScheme;

    void shift(int newOffset) {
      final current = biweeklyCycleOf(
        date: todayString(),
        anchorDate: settings.biweeklyAnchorDate,
        cycleDays: cycleDays,
      );
      final start =
          addDays(current.start, newOffset * cycleDays);
      final end = addDays(start, cycleDays - 1);
      ref.read(_rangeProvider(settings).notifier).state = _Range(start, end);
    }

    Widget chip(String label, int targetOffset) {
      final isActive = offset == targetOffset;
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: isActive
                  ? scheme.primary
                  : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
              foregroundColor:
                  isActive ? scheme.onPrimary : scheme.onSurface,
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onPressed: () => shift(targetOffset),
            child: Text(label,
                style: const TextStyle(fontSize: 12), maxLines: 1),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                chip('‹ ${t.statsPrevCycle}', -1),
                chip(t.statsCurrentCycle, 0),
                chip('${t.statsNextCycle} ›', 1),
              ],
            ),
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  initialDateRange: DateTimeRange(
                      start: parseLocal(range.start),
                      end: parseLocal(range.end)),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  ref.read(_rangeProvider(settings).notifier).state = _Range(
                    formatLocal(picked.start),
                    formatLocal(picked.end),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today, size: 14),
                    const SizedBox(width: 6),
                    Text('${range.start}  →  ${range.end}',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BigTotalCard extends StatelessWidget {
  const _BigTotalCard({
    required this.totalWage,
    required this.basePay,
    required this.fuel,
    required this.tips,
  });
  final double totalWage;
  final double basePay;
  final double fuel;
  final double tips;

  @override
  Widget build(BuildContext context) {
    final t = AppL10n.of(context)!;
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(t.statsTotalEarnings, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 4),
            Text('\$${totalWage.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              '${t.statsBasePay} \$${basePay.toStringAsFixed(2)}  ·  '
              '${t.statsFuelSubsidy} \$${fuel.toStringAsFixed(2)}  ·  '
              '${t.dashboardTips} \$${tips.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem {
  const _MetricItem(this.label, this.value, this.icon, this.accent);
  final String label;
  final String value;
  final IconData icon;
  final Accent accent;
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.items});
  final List<_MetricItem> items;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final isDark = b == Brightness.dark;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.4,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        for (final m in items)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: m.accent.bgFor(b),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? m.accent.fg.withValues(alpha: 0.25)
                        : Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(m.icon, color: m.accent.fgFor(b), size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        m.label,
                        style: TextStyle(
                          fontSize: 11,
                          color: m.accent.fgFor(b).withValues(alpha: 0.85),
                        ),
                      ),
                      Text(
                        m.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: m.accent.fgFor(b),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StackedBarChart extends StatelessWidget {
  const _StackedBarChart({required this.daily});
  final List<_DailyStat> daily;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxY = daily
        .map((d) =>
            d.summary.basePayment + d.summary.fuelFeeTotal + d.summary.totalTips)
        .fold<double>(0, (a, b) => a > b ? a : b) *
        1.2;

    final baseColor = scheme.primary;
    final tipsColor = Colors.amber.shade400;
    final fuelColor = Colors.green.shade400;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 12),
        child: Column(
          children: [
            _legend(baseColor, tipsColor, fuelColor),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  maxY: maxY == 0 ? 10 : maxY,
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: [
                    for (var i = 0; i < daily.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: daily[i].summary.basePayment +
                                daily[i].summary.fuelFeeTotal +
                                daily[i].summary.totalTips,
                            width: daily.length > 16 ? 6 : 12,
                            borderRadius: BorderRadius.circular(2),
                            rodStackItems: [
                              BarChartRodStackItem(
                                0,
                                daily[i].summary.basePayment,
                                baseColor,
                              ),
                              BarChartRodStackItem(
                                daily[i].summary.basePayment,
                                daily[i].summary.basePayment +
                                    daily[i].summary.fuelFeeTotal,
                                fuelColor,
                              ),
                              BarChartRodStackItem(
                                daily[i].summary.basePayment +
                                    daily[i].summary.fuelFeeTotal,
                                daily[i].summary.basePayment +
                                    daily[i].summary.fuelFeeTotal +
                                    daily[i].summary.totalTips,
                                tipsColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY == 0 ? 1 : maxY / 4,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: scheme.outlineVariant.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (v, _) => Text('\$${v.toInt()}',
                            style: const TextStyle(fontSize: 10)),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        interval: _labelInterval(daily.length),
                        getTitlesWidget: (v, meta) {
                          final i = v.toInt();
                          if (i < 0 || i >= daily.length) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 6,
                            child: Transform.rotate(
                              angle: -0.7, // ~-40°
                              child: Text(
                                daily[i].date.substring(5), // MM-DD
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) =>
                          scheme.inverseSurface.withValues(alpha: 0.9),
                      getTooltipItem: (group, _, rod, __) {
                        final d = daily[group.x];
                        return BarTooltipItem(
                          '${d.date}\n'
                          'Base \$${d.summary.basePayment.toStringAsFixed(2)}\n'
                          'Fuel \$${d.summary.fuelFeeTotal.toStringAsFixed(2)}\n'
                          'Tips \$${d.summary.totalTips.toStringAsFixed(2)}',
                          TextStyle(
                              color: scheme.onInverseSurface, fontSize: 11),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 标签间隔：根据区间长度自适应，避免重叠
  /// 14 天显示全部、≤30 天每 2 天、≤60 天每 5 天、再大每 7 天
  double _labelInterval(int n) {
    if (n <= 14) return 1;
    if (n <= 30) return 2;
    if (n <= 60) return 5;
    return 7;
  }

  Widget _legend(Color base, Color tips, Color fuel) {
    Widget item(Color c, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 10,
                height: 10,
                decoration:
                    BoxDecoration(color: c, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        item(base, 'Base'),
        item(fuel, 'Fuel'),
        item(tips, 'Tips'),
      ],
    );
  }
}

class _CompositionPie extends StatelessWidget {
  const _CompositionPie({
    required this.basePay,
    required this.tips,
    required this.fuel,
  });
  final double basePay;
  final double tips;
  final double fuel;

  @override
  Widget build(BuildContext context) {
    final total = basePay + tips + fuel.abs();
    final scheme = Theme.of(context).colorScheme;
    final baseColor = scheme.primary;
    final tipsColor = Colors.amber.shade400;
    final fuelColor = Colors.green.shade400;

    if (total == 0) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text('—')),
        ),
      );
    }

    String pct(double v) => '${(v / total * 100).toStringAsFixed(1)}%';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: PieChart(PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 32,
                sections: [
                  PieChartSectionData(
                      value: basePay,
                      color: baseColor,
                      radius: 38,
                      title: pct(basePay),
                      titleStyle: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  PieChartSectionData(
                      value: fuel.abs(),
                      color: fuelColor,
                      radius: 38,
                      title: pct(fuel.abs()),
                      titleStyle: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  PieChartSectionData(
                      value: tips,
                      color: tipsColor,
                      radius: 38,
                      title: pct(tips),
                      titleStyle: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ],
              )),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _legendItem(baseColor, 'Base',
                      '\$${basePay.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _legendItem(fuelColor, 'Fuel',
                      '\$${fuel.abs().toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _legendItem(
                      tipsColor, 'Tips', '\$${tips.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(Color c, String label, String value) => Row(
        children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: c, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Expanded(
              child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(value,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      );
}
