import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/calc/order_calc.dart';
import '../core/db/database.dart';
import '../core/theme/accents.dart';
import '../l10n/generated/app_localizations.dart';
import '../providers/providers.dart';
import '../widgets/order_form_sheet.dart';
import 'dashboard_page.dart' show paymentLabel;

final _allOrdersProvider = StreamProvider.autoDispose<List<Order>>(
  (ref) => ref.watch(orderRepositoryProvider).watchAll(),
);

final _searchProvider = StateProvider.autoDispose<String>((_) => '');

class _AddressStat {
  const _AddressStat({
    required this.address,
    required this.totalTips,
    required this.orderCount,
    required this.totalIncome,
    required this.orders,
  });
  final String address;
  final double totalTips;
  final int orderCount;
  final double totalIncome;
  final List<Order> orders;
  double get avgTip => orderCount == 0 ? 0 : totalTips / orderCount;
}

class LeaderboardView extends ConsumerWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppL10n.of(context)!;
    final settingsAsync = ref.watch(settingsStreamProvider);
    final ordersAsync = ref.watch(_allOrdersProvider);
    final query = ref.watch(_searchProvider).trim().toLowerCase();

    return settingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (settings) {
          final params = WageParams.fromSettings(settings);
          final orders = ordersAsync.valueOrNull ?? const <Order>[];

          // 按地址聚合（小写、去 trim）
          // 空地址也聚合为 (无地址)；只是它默认排序仍按 tips
          final grouped = groupBy(orders, (Order o) {
            final a = o.address.trim();
            return a.isEmpty ? '' : a;
          });

          final stats = <_AddressStat>[];
          for (final entry in grouped.entries) {
            double tips = 0;
            double income = 0;
            for (final o in entry.value) {
              final c = calcOrder(o, params);
              tips += c.tipsTotal;
              income += c.totalIncome;
            }
            stats.add(_AddressStat(
              address: entry.key,
              totalTips: tips,
              orderCount: entry.value.length,
              totalIncome: income,
              orders: entry.value,
            ));
          }
          // 过滤：必须有地址；其余按搜索或 tips>0
          var filtered = stats.where((s) {
            if (s.address.isEmpty) return false;
            if (query.isNotEmpty) {
              return s.address.toLowerCase().contains(query);
            }
            return s.totalTips > 0;
          }).toList();
          filtered.sort((a, b) => b.totalTips.compareTo(a.totalTips));

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: t.leaderboardSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => ref
                                .read(_searchProvider.notifier)
                                .state = '',
                          ),
                    isDense: true,
                  ),
                  onChanged: (v) =>
                      ref.read(_searchProvider.notifier).state = v,
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(t.leaderboardEmpty,
                            style: TextStyle(color: Colors.grey.shade600)),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) => _RankTile(
                          rank: i + 1,
                          stat: filtered[i],
                          params: params,
                        ),
                      ),
              ),
            ],
          );
        },
    );
  }
}

class _RankTile extends StatelessWidget {
  const _RankTile({
    required this.rank,
    required this.stat,
    required this.params,
  });
  final int rank;
  final _AddressStat stat;
  final WageParams params;

  @override
  Widget build(BuildContext context) {
    final t = AppL10n.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final b = Theme.of(context).brightness;
    final accent = switch (rank) {
      1 => AppAccents.amber,
      2 => AppAccents.teal,
      3 => AppAccents.orange,
      _ => AppAccents.indigo,
    };
    final displayAddr =
        stat.address.isEmpty ? t.leaderboardNoAddress : stat.address;

    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showAddressOrdersSheet(context, stat, params),
        child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.bgFor(b),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: rank <= 3
                  ? Text(switch (rank) { 1 => '🥇', 2 => '🥈', _ => '🥉' },
                      style: const TextStyle(fontSize: 22))
                  : Text('$rank',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: accent.fgFor(b))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayAddr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${t.leaderboardOrders(stat.orderCount)} · '
                    '${t.leaderboardAvgTip} \$${stat.avgTip.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 11, color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${stat.totalTips.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: accent.fgFor(b))),
                Text('💵',
                    style: TextStyle(
                        fontSize: 10, color: scheme.onSurfaceVariant)),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}

void _showAddressOrdersSheet(
  BuildContext context,
  _AddressStat stat,
  WageParams params,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (ctx) => _AddressOrdersSheet(stat: stat, params: params),
  );
}

class _AddressOrdersSheet extends StatelessWidget {
  const _AddressOrdersSheet({required this.stat, required this.params});
  final _AddressStat stat;
  final WageParams params;

  @override
  Widget build(BuildContext context) {
    final t = AppL10n.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final displayAddr =
        stat.address.isEmpty ? t.leaderboardNoAddress : stat.address;
    final orders = [...stat.orders]
      ..sort((a, b) => b.date.compareTo(a.date));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayAddr,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  '${t.leaderboardOrders(stat.orderCount)} · '
                  '\$${stat.totalTips.toStringAsFixed(2)} · '
                  '${t.leaderboardAvgTip} \$${stat.avgTip.toStringAsFixed(2)}',
                  style:
                      TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) =>
                  _AddressOrderTile(order: orders[i], params: params),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressOrderTile extends StatelessWidget {
  const _AddressOrderTile({required this.order, required this.params});
  final Order order;
  final WageParams params;

  @override
  Widget build(BuildContext context) {
    final t = AppL10n.of(context)!;
    final c = calcOrder(order, params);
    final scheme = Theme.of(context).colorScheme;
    final b = Theme.of(context).brightness;
    final style = PaymentStyle.of(order.paymentType);

    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).pop();
          showOrderFormSheet(context,
              defaultDate: order.date, existing: order);
        },
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
                child: Icon(style.icon,
                    color: style.accent.fgFor(b), size: 22),
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
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${order.date} · \$${order.orderValue.toStringAsFixed(2)} · '
                      '${order.distanceKm.toStringAsFixed(1)}${t.commonKm}',
                      style: TextStyle(
                          fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
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
                  Text(
                    '${t.dashboardTips} \$${c.tipsTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 11, color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
