import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'db/database.dart';

class ExportResult {
  const ExportResult({required this.orders, required this.workTimes});
  final int orders;
  final int workTimes;
}

/// 备份文件扩展名（本质是 .xlsx 容器）
const kBackupExtension = 'shbak';

const List<String> kOrdersSheetColumns = [
  'date',
  'orderNumber',
  'paymentType',
  'orderValue',
  'paymentAmount',
  'changeReturned',
  'extraCashTip',
  'distanceKm',
  'address',
  'notes',
  'createdAt',
  'updatedAt',
];

const List<String> kWorkTimesSheetColumns = [
  'date',
  'startTime',
  'endTime',
  'workHours',
];

const kOrdersSheet = 'Orders';
const kWorkTimesSheet = 'WorkTimes';

/// 把当前数据库里的全部订单与工时编码为 xlsx 字节，可独立测试。
Future<({ExportResult result, List<int> bytes})> buildBackupBytes(
  AppDatabase db,
) async {
  final orders = await db.select(db.orders).get();
  final workTimes = await db.select(db.workTimes).get();

  final excel = Excel.createExcel();
  if (excel.sheets.containsKey('Sheet1')) {
    excel.delete('Sheet1');
  }

  excel[kOrdersSheet].appendRow(
    kOrdersSheetColumns.map<CellValue?>(TextCellValue.new).toList(),
  );
  for (final o in orders) {
    excel[kOrdersSheet].appendRow(<CellValue?>[
      TextCellValue(o.date),
      TextCellValue(o.orderNumber),
      TextCellValue(o.paymentType),
      DoubleCellValue(o.orderValue),
      DoubleCellValue(o.paymentAmount),
      DoubleCellValue(o.changeReturned),
      DoubleCellValue(o.extraCashTip),
      DoubleCellValue(o.distanceKm),
      TextCellValue(o.address),
      TextCellValue(o.notes),
      TextCellValue(o.createdAt.toIso8601String()),
      TextCellValue(o.updatedAt.toIso8601String()),
    ]);
  }

  excel[kWorkTimesSheet].appendRow(
    kWorkTimesSheetColumns.map<CellValue?>(TextCellValue.new).toList(),
  );
  for (final w in workTimes) {
    excel[kWorkTimesSheet].appendRow(<CellValue?>[
      TextCellValue(w.date),
      TextCellValue(w.startTime),
      TextCellValue(w.endTime),
      DoubleCellValue(w.workHours),
    ]);
  }
  // 用一次后默认 sheet 指向 Orders，避免使用者打开看到空 sheet
  excel.setDefaultSheet(kOrdersSheet);

  final bytes = excel.encode();
  if (bytes == null) throw Exception('Failed to encode backup xlsx');

  return (
    result:
        ExportResult(orders: orders.length, workTimes: workTimes.length),
    bytes: bytes,
  );
}

/// 写入临时文件并唤起系统分享面板。默认扩展名是 .shbak。
Future<ExportResult> exportBackupToFile(
  AppDatabase db, {
  String filenameStem = 'trip-wage-backup',
  String extension = kBackupExtension,
}) async {
  final built = await buildBackupBytes(db);
  final stamp = DateTime.now()
      .toIso8601String()
      .replaceAll(RegExp(r'[:.]'), '-');
  final dir = await getTemporaryDirectory();
  final file = File(p.join(dir.path, '$filenameStem-$stamp.$extension'));
  await file.writeAsBytes(built.bytes);
  await Share.shareXFiles([XFile(file.path)]);
  return built.result;
}
