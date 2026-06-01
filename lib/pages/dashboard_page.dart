import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/calc/order_calc.dart';
import '../core/date_utils.dart';
import '../core/db/database.dart';
import '../core/excel_export.dart';
import '../core/theme/accents.dart';
import '../l10n/generated/app_localizations.dart';
import '../providers/providers.dart';
import '../widgets/order_form_sheet.dart';

final _ordersForDateProvider =
    StreamProvider.autoDispose.family<List<Order>, String>(
  (ref, date) => ref.watch(orderRepositoryProvider).watchByDate(date),
);

final _workTimeForDateProvider =
    StreamProvider.autoDispose.family<WorkTime?, String>(
  (ref, date) => ref.watch(workTimeRepositoryProvider).watchByDate(date),
);

String paymentLabel(BuildContext ctx, String type) {
  final t = AppL10n.of(ctx)!;
  return switch (type) {
    'online' => t.paymentOnline,
    'card' => t.paymentCard,
    'cash' => t.paymentCash,
    'mixed' => t.paymentMixed,
    _ => type,
  };
}

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppL10n.of(context)!;
    final date = ref.watch(currentDateProvider);
    final ordersAsync = ref.watch(_ordersForDateProvider(date));
    final workTimeAsync = ref.watch(_workTimeForDateProvider(date));
    final settingsAsync = ref.watch(settingsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.navDashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),
            tooltip: 'Export',
            onPressed: () async {
              final params = WageParams.fromSettings(
                  ref.read(settingsStreamProvider).requireValue);
              final orders = await ref
                  .read(orderRepositoryProvider)
                  .getByDate(date);
              if (orders.isEmpty) return;
              await exportOrdersToExcel(
                orders: orders,
                params: params,
                filenameStem: 'tripwage-$date',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: t.commonBackToToday,
            onPressed: () =>
                ref.read(currentDateProvider.notifier).state = todayString(),
          ),
        ],
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Settings error: $e')),
        data: (settings) {
          final params = WageParams.fromSettings(settings);
          final orders = ordersAsync.valueOrNull ?? const <Order>[];
          final workTime = workTimeAsync.valueOrNull;
          final workHours = workTime?.workHours ?? 0.0;
          final summary = calcDailySummary(
            orders: orders,
            workHours: workHours,
            params: params,
          );

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(_ordersForDateProvider(date)),
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _DateNavBar(date: date),
                const SizedBox(height: 12),
                _WorkTimeCard(date: date, workTime: workTime),
                const SizedBox(height: 12),
                _SummaryCard(summary: summary),
                const SizedBox(height: 12),
                _SettlementCard(summary: summary),
                const SizedBox(height: 16),
                Text(t.dashboardTodayOrders(orders.length),
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (orders.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(t.dashboardEmpty,
                          style: TextStyle(color: Colors.grey.shade600)),
                    ),
                  )
                else
                  ...orders.expand((o) => [
                        _OrderTile(order: o, params: params),
                        const SizedBox(height: 8),
                      ]),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showOrderFormSheet(context, defaultDate: date),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DateNavBar extends ConsumerWidget {
  const _DateNavBar({required this.date});
  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppL10n.of(context)!;
    final isToday = date == todayString();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => ref.read(currentDateProvider.notifier).state =
                  addDays(date, -1),
            ),
            Expanded(
              child: TextButton.icon(
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(
                  '$date${isToday ? "  ·  ${t.commonToday}" : ""}',
                  style: const TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  final init = parseLocal(date);
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: init,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    ref.read(currentDateProvider.notifier).state =
                        formatLocal(picked);
                  }
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => ref.read(currentDateProvider.notifier).state =
                  addDays(date, 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkTimeCard extends ConsumerStatefulWidget {
  const _WorkTimeCard({required this.date, required this.workTime});
  final String date;
  final WorkTime? workTime;

  @override
  ConsumerState<_WorkTimeCard> createState() => _WorkTimeCardState();
}

class _WorkTimeCardState extends ConsumerState<_WorkTimeCard> {
  TimeOfDay? _parse(String s) {
    if (s.isEmpty) return null;
    final p = s.split(':');
    if (p.length != 2) return null;
    return TimeOfDay(
        hour: int.tryParse(p[0]) ?? 0, minute: int.tryParse(p[1]) ?? 0);
  }

  String _format(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pick(bool isStart) async {
    final wt = widget.workTime;
    final init = _parse(isStart ? (wt?.startTime ?? '') : (wt?.endTime ?? '')) ??
        TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: init);
    if (picked == null) return;
    final start = isStart ? _format(picked) : (wt?.startTime ?? '');
    final end = isStart ? (wt?.endTime ?? '') : _format(picked);
    final hours = calcWorkHours(start, end);
    await ref.read(workTimeRepositoryProvider).upsert(
          date: widget.date,
          startTime: start,
          endTime: end,
          workHours: hours,
        );
  }

  Future<void> _clear(bool isStart) async {
    final wt = widget.workTime;
    final prevStart = wt?.startTime ?? '';
    final prevEnd = wt?.endTime ?? '';
    final start = isStart ? '' : prevStart;
    final end = isStart ? prevEnd : '';
    await ref.read(workTimeRepositoryProvider).upsert(
          date: widget.date,
          startTime: start,
          endTime: end,
          workHours: calcWorkHours(start, end),
        );
    if (!mounted) return;
    final t = AppL10n.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          isStart ? t.dashboardClearedStart : t.dashboardClearedEnd),
      action: SnackBarAction(
        label: t.commonUndo,
        onPressed: () async {
          await ref.read(workTimeRepositoryProvider).upsert(
                date: widget.date,
                startTime: prevStart,
                endTime: prevEnd,
                workHours: calcWorkHours(prevStart, prevEnd),
              );
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppL10n.of(context)!;
    final wt = widget.workTime;
    final start = wt?.startTime ?? '';
    final end = wt?.endTime ?? '';
    final hours = wt?.workHours ?? 0;
    final b = Theme.of(context).brightness;
    final accent = AppAccents.amber;

    final isDark = b == Brightness.dark;
    final fg = accent.fgFor(b);
    final gradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF4A3A1F), Color(0xFF5A3A2A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFFFFD89B), Color(0xFFFFB199)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.access_time, color: fg, size: 18),
          ),
          const SizedBox(width: 8),
          Text(t.dashboardWorkTime,
              style: TextStyle(
                  color: fg, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => _pick(true),
                    onLongPress: start.isEmpty ? null : () => _clear(true),
                    child: Text(
                      start.isEmpty ? t.dashboardStart : start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Text('-'),
                ),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => _pick(false),
                    onLongPress: end.isEmpty ? null : () => _clear(false),
                    child: Text(
                      end.isEmpty ? t.dashboardEnd : end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text('${hours.toStringAsFixed(1)}${t.commonHours}',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: fg)),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});
  final DailySummary summary;

  @override
  Widget build(BuildContext context) {
    final t = AppL10n.of(context)!;
    final b = Theme.of(context).brightness;
    final isDark = b == Brightness.dark;
    final s = summary;
    final orderText = s.longTrips > 0
        ? '${s.actualTrips}+${s.longTrips}'
        : '${s.actualTrips}';
    final baseAndFuel = s.basePayment + s.fuelFeeTotal;

    final heroGradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF1E293B), Color(0xFF334155)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFFA1C4FD), Color(0xFFC2E9FB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
    final heroFg = isDark ? Colors.white : const Color(0xFF1E3A8A);
    final heroFgMuted =
        heroFg.withValues(alpha: 0.75);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA1C4FD).withValues(alpha: isDark ? 0.0 : 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(gradient: heroGradient),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.dashboardTotalIncome,
                            style: TextStyle(
                                fontSize: 13,
                                color: heroFgMuted)),
                        const SizedBox(height: 4),
                        Text('\$${s.totalWage.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: heroFg,
                                height: 1.1)),
                        const SizedBox(height: 6),
                        Text(
                          '${t.dashboardBaseAndFuel} \$${baseAndFuel.toStringAsFixed(2)}  ·  '
                          '${t.dashboardTips} \$${s.totalTips.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 11,
                              color: heroFgMuted),
                        ),
                      ],
                    ),
                  ),
                  const Text('✨', style: TextStyle(fontSize: 32)),
                ],
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              padding: const EdgeInsets.all(12),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  _Metric(
                      label: t.dashboardOrders,
                      value: orderText,
                      icon: Icons.inventory_2_outlined,
                      accent: AppAccents.purple,
                      emphasized: true),
                  _Metric(
                      label: t.dashboardTips,
                      value: '\$${s.totalTips.toStringAsFixed(2)}',
                      icon: Icons.savings_outlined,
                      accent: AppAccents.amber,
                      emphasized: true),
                  _Metric(
                      label: t.dashboardDistance,
                      value:
                          '${s.totalDistance.toStringAsFixed(1)} ${t.commonKm}',
                      icon: Icons.directions_car_outlined,
                      accent: AppAccents.teal),
                  _Metric(
                      label: t.dashboardHourlyRate,
                      value:
                          '\$${s.hourlyWage.toStringAsFixed(2)}/${t.commonHours}',
                      icon: Icons.trending_up,
                      accent: AppAccents.green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
    this.emphasized = false,
  });
  final String label;
  final String value;
  final IconData icon;
  final Accent accent;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final isDark = b == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: accent.bgFor(b),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark
                  ? accent.fg.withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accent.fgFor(b), size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 10,
                        color: accent.fgFor(b).withValues(alpha: 0.85))),
                Text(value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: emphasized ? 20 : 14,
                        fontWeight: FontWeight.bold,
                        color: accent.fgFor(b))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettlementCard extends StatelessWidget {
  const _SettlementCard({required this.summary});
  final DailySummary summary;

  @override
  Widget build(BuildContext context) {
    final t = AppL10n.of(context)!;
    final b = Theme.of(context).brightness;
    final isDark = b == Brightness.dark;
    final v = summary.restaurantSettlement;
    final owesRestaurant = v >= 0;
    final accent = owesRestaurant ? AppAccents.pink : AppAccents.green;
    final sign = owesRestaurant ? '−' : '+';
    final emoji = owesRestaurant ? '💸' : '💰';

    return Container(
      decoration: BoxDecoration(
        color: accent.bgFor(b),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accent.fgFor(b).withValues(alpha: isDark ? 0.3 : 0.15),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark
                  ? accent.fg.withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    owesRestaurant
                        ? t.dashboardYouOweRestaurant
                        : t.dashboardRestaurantOwesYou,
                    style: TextStyle(
                        fontSize: 12,
                        color: accent.fgFor(b).withValues(alpha: 0.85))),
                Text('$sign\$${v.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: accent.fgFor(b))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                  '${t.dashboardCashOrders} \$${summary.cashOrderValue.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 11,
                      color: accent.fgFor(b).withValues(alpha: 0.75))),
              Text(
                  '${t.dashboardTipsFromRestaurant} \$${summary.nonCashTips.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 11,
                      color: accent.fgFor(b).withValues(alpha: 0.75))),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderTile extends ConsumerWidget {
  const _OrderTile({required this.order, required this.params});
  final Order order;
  final WageParams params;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppL10n.of(context)!;
    final c = calcOrder(order, params);
    final style = PaymentStyle.of(order.paymentType);
    final b = Theme.of(context).brightness;
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => showOrderFormSheet(context,
            defaultDate: order.date, existing: order),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: style.accent.bgFor(b),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(style.icon, color: style.accent.fgFor(b), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '#${order.orderNumber.isEmpty ? t.commonNone : order.orderNumber}',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: style.accent.bgFor(b),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            paymentLabel(context, order.paymentType),
                            style: TextStyle(
                                fontSize: 10,
                                color: style.accent.fgFor(b),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (c.isLongTrip) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppAccents.orange.bgFor(b),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              t.dashboardLongTrip,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: AppAccents.orange.fgFor(b),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${t.orderValue} \$${order.orderValue.toStringAsFixed(2)} · '
                      '${order.distanceKm.toStringAsFixed(1)}${t.commonKm}',
                      style: TextStyle(
                          fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                    if (order.address.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 12, color: scheme.onSurfaceVariant),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              order.address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: scheme.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('\$${c.totalIncome.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  if (c.tipsTotal > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${t.dashboardTips} \$${c.tipsTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppAccents.amber.fgFor(b),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
