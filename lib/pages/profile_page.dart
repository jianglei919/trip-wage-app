import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/backup_import.dart';
import '../core/data_migration.dart';
import '../core/date_utils.dart';
import '../core/db/database.dart';
import '../l10n/generated/app_localizations.dart';
import '../providers/providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppL10n.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.settingsTitle)),
      body: ref.watch(settingsStreamProvider).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            // 用 key 让设置 id 变化时（理论不会）才重建；用 initial 一次性初始化
            data: (s) => _SettingsForm(key: ValueKey(s.id), initial: s),
          ),
    );
  }
}

class _SettingsForm extends ConsumerStatefulWidget {
  const _SettingsForm({super.key, required this.initial});
  final AppSetting initial;

  @override
  ConsumerState<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends ConsumerState<_SettingsForm> {
  late final TextEditingController _baseRate;
  late final TextEditingController _fuelPerOrder;
  late final TextEditingController _longTripThreshold;
  late final TextEditingController _longTripExtraFuel;
  late final TextEditingController _biweeklyDays;
  late final TextEditingController _currency;
  late String _anchorDate;
  bool _saving = false;

  String _trim(double v) {
    final s = v.toString();
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  }

  @override
  void initState() {
    super.initState();
    final s = widget.initial;
    _baseRate = TextEditingController(text: _trim(s.baseHourlyRate));
    _fuelPerOrder = TextEditingController(text: _trim(s.fuelPerOrder));
    _longTripThreshold =
        TextEditingController(text: _trim(s.longTripThresholdKm));
    _longTripExtraFuel =
        TextEditingController(text: _trim(s.longTripExtraFuel));
    _biweeklyDays =
        TextEditingController(text: s.biweeklySettlementDays.toString());
    _currency = TextEditingController(text: s.currency);
    _anchorDate = s.biweeklyAnchorDate;
  }

  @override
  void dispose() {
    _baseRate.dispose();
    _fuelPerOrder.dispose();
    _longTripThreshold.dispose();
    _longTripExtraFuel.dispose();
    _biweeklyDays.dispose();
    _currency.dispose();
    super.dispose();
  }

  double _d(TextEditingController c, double fallback) =>
      double.tryParse(c.text.trim()) ?? fallback;

  Future<void> _saveWageParams() async {
    final t = AppL10n.of(context)!;
    setState(() => _saving = true);
    try {
      await ref.read(settingsRepositoryProvider).update(
            baseHourlyRate: _d(_baseRate, widget.initial.baseHourlyRate),
            fuelPerOrder: _d(_fuelPerOrder, widget.initial.fuelPerOrder),
            longTripThresholdKm:
                _d(_longTripThreshold, widget.initial.longTripThresholdKm),
            longTripExtraFuel:
                _d(_longTripExtraFuel, widget.initial.longTripExtraFuel),
            biweeklySettlementDays: int.tryParse(_biweeklyDays.text.trim()) ??
                widget.initial.biweeklySettlementDays,
            biweeklyAnchorDate: _anchorDate,
            currency: _currency.text.trim().isEmpty
                ? widget.initial.currency
                : _currency.text.trim(),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.commonSaved)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickAnchorDate() async {
    final init = parseLocal(_anchorDate);
    final picked = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _anchorDate = formatLocal(picked));
  }

  Future<void> _importBackup() async {
    final t = AppL10n.of(context)!;
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (picked == null || picked.files.single.path == null) return;
    final file = File(picked.files.single.path!);
    try {
      final db = ref.read(databaseProvider);
      final result = await importBackupFromFile(db, file);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            t.settingsImportSuccess(result.orders, result.workTimes)),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t.settingsImportFailed(e.toString())),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _migrateNotes() async {
    final t = AppL10n.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.settingsMigrateNotes),
        content: Text(t.settingsMigrateNotesConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t.commonCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t.commonSave)),
        ],
      ),
    );
    if (ok != true) return;
    final db = ref.read(databaseProvider);
    final count = await copyNotesToEmptyAddress(db);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.settingsMigrateNotesResult(count))),
    );
  }

  Future<void> _reset() async {
    final t = AppL10n.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.settingsResetConfirmTitle),
        content: Text(t.settingsResetConfirmMsg),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t.commonCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t.commonDelete)),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(settingsRepositoryProvider).resetToDefaults();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppL10n.of(context)!;
    final s = widget.initial;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _SectionHeader(t.settingsWageSection),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _numField(_baseRate, t.settingsBaseHourlyRate, prefix: '\$'),
                const SizedBox(height: 12),
                _numField(_fuelPerOrder, t.settingsFuelPerOrder, prefix: '\$'),
                const SizedBox(height: 12),
                _numField(
                    _longTripThreshold, t.settingsLongTripThresholdKm),
                const SizedBox(height: 12),
                _numField(
                    _longTripExtraFuel, t.settingsLongTripExtraFuel,
                    prefix: '\$'),
                const SizedBox(height: 12),
                _intField(_biweeklyDays, t.settingsBiweeklySettlementDays),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(t.settingsBiweeklyAnchorDate),
                  trailing: TextButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(_anchorDate),
                    onPressed: _pickAnchorDate,
                  ),
                ),
                const SizedBox(height: 8),
                _numField(_currency, t.settingsCurrency,
                    keyboardType: TextInputType.text),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saving ? null : _saveWageParams,
                    child: Text(_saving ? t.commonSaving : t.commonSave),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        _SectionHeader(t.settingsPreferencesSection),
        Card(
          child: Column(
            children: [
              ListTile(
                title: Text(t.settingsLanguage),
                trailing: DropdownButton<String>(
                  value: s.locale,
                  items: [
                    DropdownMenuItem(value: 'zh', child: Text(t.settingsLangZh)),
                    DropdownMenuItem(value: 'en', child: Text(t.settingsLangEn)),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      ref
                          .read(settingsRepositoryProvider)
                          .update(locale: v);
                    }
                  },
                ),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(t.settingsThemeMode),
                trailing: DropdownButton<String>(
                  value: s.themeMode,
                  items: [
                    DropdownMenuItem(
                        value: 'system', child: Text(t.settingsThemeSystem)),
                    DropdownMenuItem(
                        value: 'light', child: Text(t.settingsThemeLight)),
                    DropdownMenuItem(
                        value: 'dark', child: Text(t.settingsThemeDark)),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      ref
                          .read(settingsRepositoryProvider)
                          .update(themeMode: v);
                    }
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        _SectionHeader(t.settingsDataSection),
        Card(
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: Text(t.settingsImportBackup),
              subtitle: Text(t.settingsImportHint,
                  style: const TextStyle(fontSize: 11)),
              onTap: _importBackup,
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(t.settingsMigrateNotes),
              subtitle: Text(t.settingsMigrateNotesHint,
                  style: const TextStyle(fontSize: 11)),
              onTap: _migrateNotes,
            ),
          ]),
        ),

        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.restore, color: Colors.red),
            label: Text(t.settingsReset,
                style: const TextStyle(color: Colors.red)),
            onPressed: _reset,
          ),
        ),
        const SizedBox(height: 24),
        _SectionHeader(t.settingsAboutSection),
        Card(
          child: ListTile(
            title: Text(t.settingsVersion),
            trailing: const Text('1.0.0'),
          ),
        ),
      ],
    );
  }

  Widget _numField(TextEditingController c, String label,
      {String? prefix, TextInputType? keyboardType}) {
    return TextField(
      controller: c,
      keyboardType:
          keyboardType ?? const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: keyboardType == TextInputType.text
          ? null
          : [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        isDense: true,
      ),
    );
  }

  Widget _intField(TextEditingController c, String label) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      );
}
