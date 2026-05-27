import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wage_app/core/ocr/receipt_parser.dart';

void main() {
  group('parseReceipt', () {
    test('Card for Delivery sample', () {
      const text = '''
Mandarin Windsor
Tel:519-967-1800
Address:3100 HOWARD AVENUE
Windsor
**** Store Copy ****
Delivery 02:13PM
Order Number: 16
Operator:JIM
Batch Number:2812
Transaction ID:28-20260524-42895160
Order Time:2026-05-24 14:13:15
Name:MATHEW
Phone:519-990-8076
Address:6 DOLPHIN RD
City:WINDSOR
Map:X9
QTY Item    Price
Sub Total:    \$30.97
Delivery Charge:    \$0.00
Credit:    \$0.00
Tax    \$4.03
Amount:    \$35.00
Card for Delivery
''';
      final r = parseReceipt(text);
      expect(r.orderNumber, '16');
      expect(r.date, '2026-05-24');
      expect(r.paymentType, 'card');
      expect(r.orderValue, 35.00);
      expect(r.tip, isNull);
      expect(r.address, '6 DOLPHIN RD, WINDSOR');
    });

    test('Online with prepaid tips sample', () {
      const text = '''
Mandarin Windsor
**** Store Copy ****
WebDelivery 09:49PM
Order Number: 1
Operator:WebBot
Order Time:2026-05-23 21:49:22
Name:COLIN JAMES
Phone:519-817-3997
Address:2318 Byng Rd
City:Windsor
Postal:ON N8W 3E5
Online Order#:WI-2605235117-7865
QTY Item    Price
1 TIPS *Paid \$6.23 tips    \$0.00
Sub Total:    \$45.95
Delivery Charge:    \$6.00
Credit:    \$0.00
Tax    \$6.76
Amount:    \$58.71
Online
''';
      final r = parseReceipt(text);
      expect(r.orderNumber, '1');
      expect(r.date, '2026-05-23');
      expect(r.paymentType, 'online');
      expect(r.orderValue, 58.71);
      expect(r.tip, 6.23);
      expect(r.address, '2318 Byng Rd, Windsor, ON N8W 3E5');
    });

    test('Online without tips sample', () {
      const text = '''
Mandarin Windsor
**** Store Copy ****
WebDelivery 02:05PM
Order Number: 15
Operator:WebBot
Order Time:2026-05-24 14:05:52
Name:Alma Cruz
Phone:226-506-4740
Address:1025 Louis Ave
City:Windsor
Postal:ON M9A 1Y1
Online Order#:WI-2605240551-8326
QTY Item    Price
Sub Total:    \$62.96
Delivery Charge:    \$6.00
Credit:    \$0.00
Tax    \$8.97
Amount:    \$77.93
Online
''';
      final r = parseReceipt(text);
      expect(r.orderNumber, '15');
      expect(r.date, '2026-05-24');
      expect(r.paymentType, 'online');
      expect(r.orderValue, 77.93);
      expect(r.tip, isNull);
      expect(r.address, '1025 Louis Ave, Windsor, ON M9A 1Y1');
    });

    test('Cash sample', () {
      const text = '''
Mandarin Windsor
**** Store Copy ****
Delivery 03:25PM
Order Number: 12
Operator:AVRIL
Order Time:2025-12-28 15:25:24
Name:MANTUN
Phone:519-977-1175
Address:1862 GLADSTONE AVE.
City:WINDSOR
QTY Item    Price
Sub Total:    \$90.92
Delivery Charge:    \$0.00
Credit:    \$0.00
Tax    \$11.82
Amount:    \$102.74
Cash
''';
      final r = parseReceipt(text);
      expect(r.orderNumber, '12');
      expect(r.date, '2025-12-28');
      expect(r.paymentType, 'cash');
      expect(r.orderValue, 102.74);
      expect(r.tip, isNull);
      expect(r.address, '1862 GLADSTONE AVE., WINDSOR');
    });

    test('real OCR with misreads (Mnber, Anount, S\$, Unit)', () {
      // 实际 ML Kit 输出：列布局错乱、$ 被识成 S、Number 被识成 Mnber
      const text = '''
Mandarin Windsor
Tel:519-967-1800
Address:3100 HOWARD AVENUE
Windsor
**** Store Copy ****
Delivery 06:10PM
Order Mnber: 32
Operator:AVRIL
Order Time:2025-12-07 18:10:23
Name: 1RESON
Phone:519-560-0000
Address: 1624 LAUZON PO.
Unit:623
City:WINDSOR
QTY Item
Anount:
CHICKEN WITH CHINESE MEXE \$15.99
Credit:
3 SOY SAUCE
Sub Total:
Delivery Charge:
GST 5%:
Card for Delivery
Price
\$5.98
\$86.93
\$0.00
\$0.00
\$11.30
S98.23
''';
      final r = parseReceipt(text);
      expect(r.orderNumber, '32');
      expect(r.date, '2025-12-07');
      expect(r.paymentType, 'card');
      expect(r.orderValue, 98.23);
      expect(r.tip, isNull);
      expect(r.address, '1624 LAUZON PO., Unit 623, WINDSOR');
    });

    test('real OCR with Name misread as kame and trailing comma in Address',
        () {
      const text = '''
Mandarin Windsor
Tel:519-967-1800
Address:3100 HOWARD AVENUE
Windsor
*** Customer Copy ****
Delivery 06:10PM
Order Nunber: 32
Operator :AVRIL
Order Time:2025-12-07 18:10:23
kame: RESON
Phone:519-560-0777
Address: 1624 LAUZON PO,
Unit:623
City:WINDSOR
Anount:
Card for Delivery
\$86.93
\$0.00
\$0.00
\$11.30
\$98.23
''';
      final r = parseReceipt(text);
      expect(r.orderNumber, '32');
      expect(r.date, '2025-12-07');
      expect(r.paymentType, 'card');
      expect(r.orderValue, 98.23);
      expect(r.address, '1624 LAUZON PO, Unit 623, WINDSOR');
    });

    test('heavily degraded OCR (Atress, Rostal, no City)', () {
      const text = '''
Mantarin Windsor
WebDelivery 03:42PM
Order ater: 2
Oroer Tine:2006-06-24 15:42:29
kne: fcbin Stdle
Pure:519-971-496
Atress:2191
Rostal: ON NN 28
Online
''';
      final r = parseReceipt(text);
      expect(r.orderNumber, '2');
      expect(r.date, '2006-06-24');
      expect(r.paymentType, 'online');
      expect(r.address, '2191, ON NN 28');
    });

    test('returns nulls for unrelated text', () {
      final r = parseReceipt('hello world\nnothing useful');
      expect(r.orderNumber, isNull);
      expect(r.date, isNull);
      expect(r.paymentType, isNull);
      expect(r.orderValue, isNull);
      expect(r.tip, isNull);
      expect(r.address, isNull);
    });
  });
}
