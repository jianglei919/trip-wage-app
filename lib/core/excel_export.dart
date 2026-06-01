import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'calc/order_calc.dart';
import 'db/database.dart';

class OrderExportResult {
  const OrderExportResult({required this.count, required this.filename});
  final int count;
  final String filename;
}

/// 把订单列表导出为 .xlsx 并唤起系统分享
Future<OrderExportResult> exportOrdersToExcel({
  required List<Order> orders,
  required WageParams params,
  required String filenameStem,
}) async {
  final excel = Excel.createExcel();
  final sheetName = 'Order Details';
  final sheet = excel[sheetName];
  excel.setDefaultSheet(sheetName);
  if (excel.sheets.containsKey('Sheet1')) {
    excel.delete('Sheet1');
  }

  const headers = [
    'Date', 'Order#', 'Payment',
    'Order Value', 'Payment Amt', 'Change', 'Extra Cash Tip',
    'Distance(km)', 'Long Trip',
    'Total Tips', 'Fuel Fee', 'Total Income', 'Address', 'Notes',
  ];
  sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());

  for (final o in orders) {
    final c = calcOrder(o, params);
    sheet.appendRow([
      TextCellValue(o.date),
      TextCellValue(o.orderNumber),
      TextCellValue(o.paymentType),
      DoubleCellValue(o.orderValue),
      DoubleCellValue(o.paymentAmount),
      DoubleCellValue(o.changeReturned),
      DoubleCellValue(o.extraCashTip),
      DoubleCellValue(o.distanceKm),
      TextCellValue(c.isLongTrip ? 'Yes' : 'No'),
      DoubleCellValue(c.tipsTotal),
      DoubleCellValue(c.fuelFee),
      DoubleCellValue(c.totalIncome),
      TextCellValue(o.address),
      TextCellValue(o.notes),
    ]);
  }

  final bytes = excel.encode();
  if (bytes == null) throw Exception('Failed to encode xlsx');

  final dir = await getTemporaryDirectory();
  final filename = '$filenameStem.xlsx';
  final file = File(p.join(dir.path, filename));
  await file.writeAsBytes(bytes);

  await Share.shareXFiles([XFile(file.path)]);
  return OrderExportResult(count: orders.length, filename: filename);
}
