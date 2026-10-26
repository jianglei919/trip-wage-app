import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wage_app/core/money_format.dart';

void main() {
  group('formatMoney', () {
    test('positive', () {
      expect(formatMoney(3), '\$3.00');
      expect(formatMoney(12.346), '\$12.35');
    });
    test('negative puts sign before \$', () {
      expect(formatMoney(-2), '-\$2.00');
      expect(formatMoney(-0.5), '-\$0.50');
    });
    test('tiny float noise does not render as -\$0.00', () {
      expect(formatMoney(-0.0000001), '\$0.00');
      expect(formatMoney(-0.0), '\$0.00');
    });
  });
}
