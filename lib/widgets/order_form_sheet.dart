import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/db/database.dart';
import '../l10n/generated/app_localizations.dart';
import '../providers/providers.dart';

/// 添加或编辑订单的 BottomSheet
/// existing 为 null 表示新增
Future<void> showOrderFormSheet(
  BuildContext context, {
  required String defaultDate,
  Order? existing,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
      ),
      child: _OrderFormSheet(defaultDate: defaultDate, existing: existing),
    ),
  );
}

class _OrderFormSheet extends ConsumerStatefulWidget {
  const _OrderFormSheet({required this.defaultDate, this.existing});
  final String defaultDate;
  final Order? existing;

  @override
  ConsumerState<_OrderFormSheet> createState() => _OrderFormSheetState();
}

class _OrderFormSheetState extends ConsumerState<_OrderFormSheet> {
  late String _date;
  late String _paymentType;
  late TextEditingController _orderNumber;
  late TextEditingController _orderValue;
  late TextEditingController _tip;            // online/card 模式
  late TextEditingController _paymentAmount;  // cash/mixed 模式
  late TextEditingController _changeReturned; // cash/mixed 模式
  late TextEditingController _extraCashTip;
  late TextEditingController _distanceKm;
  late TextEditingController _address;
  late TextEditingController _notes;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _date = e?.date ?? widget.defaultDate;
    _paymentType = e?.paymentType ?? 'online';
    _orderNumber = TextEditingController(text: e?.orderNumber ?? '');
    _orderValue = TextEditingController(
        text: e == null ? '' : _trim(e.orderValue));
    final derivedTip = e == null
        ? ''
        : ((_paymentType == 'online' || _paymentType == 'card') &&
                (e.paymentAmount - e.orderValue) > 0
            ? _trim(e.paymentAmount - e.orderValue)
            : '');
    _tip = TextEditingController(text: derivedTip);
    _paymentAmount =
        TextEditingController(text: e == null ? '' : _trim(e.paymentAmount));
    _changeReturned =
        TextEditingController(text: e == null ? '' : _trim(e.changeReturned));
    _extraCashTip = TextEditingController(
        text: e == null || e.extraCashTip == 0 ? '' : _trim(e.extraCashTip));
    _distanceKm =
        TextEditingController(text: e == null ? '' : _trim(e.distanceKm));
    _address = TextEditingController(text: e?.address ?? '');
    _notes = TextEditingController(text: e?.notes ?? '');
  }

  String _trim(double v) {
    final s = v.toStringAsFixed(2);
    return s.endsWith('.00') ? s.substring(0, s.length - 3) : s;
  }

  @override
  void dispose() {
    _orderNumber.dispose();
    _orderValue.dispose();
    _tip.dispose();
    _paymentAmount.dispose();
    _changeReturned.dispose();
    _extraCashTip.dispose();
    _distanceKm.dispose();
    _address.dispose();
    _notes.dispose();
    super.dispose();
  }

  double _num(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;

  double _computePaymentAmount() {
    if (_paymentType == 'online' || _paymentType == 'card') {
      return _num(_orderValue) + _num(_tip);
    }
    return _num(_paymentAmount);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final repo = ref.read(orderRepositoryProvider);
    try {
      if (widget.existing == null) {
        await repo.insert(OrdersCompanion.insert(
          date: _date,
          orderNumber: drift.Value(_orderNumber.text.trim()),
          paymentType: drift.Value(_paymentType),
          orderValue: drift.Value(_num(_orderValue)),
          paymentAmount: drift.Value(_computePaymentAmount()),
          changeReturned: drift.Value(_num(_changeReturned)),
          extraCashTip: drift.Value(_num(_extraCashTip)),
          distanceKm: drift.Value(_num(_distanceKm)),
          address: drift.Value(_address.text.trim()),
          notes: drift.Value(_notes.text),
        ));
      } else {
        await repo.update(widget.existing!.copyWith(
          date: _date,
          orderNumber: _orderNumber.text.trim(),
          paymentType: _paymentType,
          orderValue: _num(_orderValue),
          paymentAmount: _computePaymentAmount(),
          changeReturned: _num(_changeReturned),
          extraCashTip: _num(_extraCashTip),
          distanceKm: _num(_distanceKm),
          address: _address.text.trim(),
          notes: _notes.text,
        ));
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final e = widget.existing;
    if (e == null) return;
    final t = AppL10n.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.orderDeleteConfirmTitle),
        content: Text('#${e.orderNumber.isEmpty ? t.commonNone : e.orderNumber}'
            ' · ${e.date}\n${t.orderDeleteConfirmMsg}'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t.commonCancel)),
          FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t.commonDelete)),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(orderRepositoryProvider).delete(e.id);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final init = DateTime.tryParse(_date) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final m = picked.month.toString().padLeft(2, '0');
      final d = picked.day.toString().padLeft(2, '0');
      setState(() => _date = '${picked.year}-$m-$d');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppL10n.of(context)!;
    final isOnlineOrCard = _paymentType == 'online' || _paymentType == 'card';
    final isCashOrMixed = _paymentType == 'cash' || _paymentType == 'mixed';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Text(widget.existing == null ? t.orderAddTitle : t.orderEditTitle,
                  style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              if (widget.existing != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: _saving ? null : _delete,
                ),
            ],
          ),
          const SizedBox(height: 12),

          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(_date),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _orderNumber,
                decoration: InputDecoration(
                  labelText: t.orderNumber,
                  isDense: true,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: _paymentType,
            decoration: InputDecoration(
              labelText: t.orderPaymentType,
              isDense: true,
            ),
            items: [
              DropdownMenuItem(value: 'online', child: Text(t.paymentOnline)),
              DropdownMenuItem(value: 'card', child: Text(t.paymentCard)),
              DropdownMenuItem(value: 'cash', child: Text(t.paymentCash)),
              DropdownMenuItem(value: 'mixed', child: Text(t.paymentMixed)),
            ],
            onChanged: (v) => setState(() => _paymentType = v!),
          ),
          const SizedBox(height: 12),

          _numField(_orderValue, t.orderValue, prefix: '\$'),

          if (isOnlineOrCard) ...[
            const SizedBox(height: 12),
            _numField(_tip, t.orderTip, prefix: '\$'),
          ],
          if (isCashOrMixed) ...[
            const SizedBox(height: 12),
            _numField(_paymentAmount, t.orderPaymentAmount, prefix: '\$'),
            const SizedBox(height: 12),
            _numField(_changeReturned, t.orderChange, prefix: '\$'),
          ],
          const SizedBox(height: 12),
          _numField(_extraCashTip, t.orderExtraCashTip, prefix: '\$'),
          const SizedBox(height: 12),
          _numField(_distanceKm, t.orderDistance),

          const SizedBox(height: 12),
          TextField(
            controller: _address,
            decoration: InputDecoration(
              labelText: t.orderAddress,
              prefixIcon: const Icon(Icons.location_on_outlined, size: 18),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: t.orderNotes,
              isDense: true,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _saving ? null : () => Navigator.pop(context),
                  child: Text(t.commonCancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? t.commonSaving : t.commonSave),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _numField(TextEditingController c, String label, {String? prefix}) {
    return TextField(
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        isDense: true,
      ),
    );
  }
}
