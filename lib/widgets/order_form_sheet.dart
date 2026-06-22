import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../core/db/database.dart';
import '../core/ocr/receipt_parser.dart';
import '../core/ocr/receipt_scanner.dart';
import '../core/theme/accents.dart';
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
    showDragHandle: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.92,
    ),
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
  bool _scanning = false;
  final ReceiptScanner _scanner = ReceiptScanner();

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
    _scanner.dispose();
    super.dispose();
  }

  Future<void> _scanReceipt() async {
    final t = AppL10n.of(context)!;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(t.orderScanFromCamera),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(t.orderScanFromGallery),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    setState(() => _scanning = true);
    try {
      final result = await _scanner.scan(source: source);
      if (!mounted) return;
      if (result == null) return;
      debugPrint('=== RAW OCR TEXT ===\n${result.rawText}\n=== END ===');
      _applyParsedReceipt(result.parsed);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.orderScanSuccess),
          action: SnackBarAction(
            label: '查看原文',
            onPressed: () => _showRawText(result.rawText),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.orderScanFailed(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  void _showRawText(String text) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('OCR 原始文本'),
        content: SingleChildScrollView(
          child: SelectableText(
            text,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(content: Text('已复制到剪贴板')),
              );
            },
            child: const Text('复制'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _applyParsedReceipt(ParsedReceipt r) {
    setState(() {
      if (r.date != null) _date = r.date!;
      if (r.paymentType != null) _paymentType = r.paymentType!;
      if (r.orderNumber != null && _orderNumber.text.trim().isEmpty) {
        _orderNumber.text = r.orderNumber!;
      }
    });
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
          if (widget.existing == null) ...[
            const SizedBox(height: 8),
            Builder(builder: (context) {
              final b = Theme.of(context).brightness;
              final accent = AppAccents.teal;
              return FilledButton.icon(
                onPressed: (_saving || _scanning) ? null : _scanReceipt,
                style: FilledButton.styleFrom(
                  backgroundColor: accent.bgFor(b),
                  foregroundColor: accent.fgFor(b),
                  minimumSize: const Size.fromHeight(40),
                ),
                icon: _scanning
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: accent.fgFor(b),
                        ),
                      )
                    : const Icon(Icons.document_scanner_outlined, size: 18),
                label:
                    Text(_scanning ? t.orderScanning : t.orderScanReceipt),
              );
            }),
          ],
          const SizedBox(height: 12),


          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(4),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: t.orderDate,
                      isDense: true,
                      suffixIcon:
                          const Icon(Icons.calendar_today, size: 16),
                    ),
                    child: Text(_date),
                  ),
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
            ],
          ),
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
              hintText: '1525 Dufferin Pl, Windsor, ON N8X 3K6',
              prefixIcon: const Icon(Icons.location_on_outlined, size: 18),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: t.orderNotes,
              isDense: true,
            ),
          ),
          const SizedBox(height: 16),

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
