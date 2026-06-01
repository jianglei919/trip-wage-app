import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wage_app/core/address_key.dart';

void main() {
  group('addressGroupKey', () {
    test('empty / whitespace → empty key', () {
      expect(addressGroupKey(''), '');
      expect(addressGroupKey('   '), '');
    });

    group('Canadian postal (canonical user format)', () {
      test('standard format matches itself', () {
        expect(addressGroupKey('1525 Dufferin Pl, Windsor, ON N8X 3K6'),
            'zip:N8X3K6');
      });
      test('case + inner spaces are normalized', () {
        const a = '1525 Dufferin Pl, Windsor, ON N8X 3K6';
        const b = '1525 dufferin pl, windsor, on n8x3k6';
        const c = '1525 DUFFERIN PL, WINDSOR, ON N8X  3K6';
        final ka = addressGroupKey(a);
        expect(addressGroupKey(b), ka);
        expect(addressGroupKey(c), ka);
        expect(ka, 'zip:N8X3K6');
      });
      test('different street number with same postal still groups together',
          () {
        // 用户明确接受这种行为：相同邮编默认同一地址组
        expect(
          addressGroupKey('1525 Dufferin Pl, Windsor, ON N8X 3K6'),
          addressGroupKey('1530 Dufferin Pl, Windsor, ON N8X 3K6'),
        );
      });
      test('matches postal even mid-string', () {
        expect(addressGroupKey('N8X 3K6 — 1525 Dufferin Pl'),
            'zip:N8X3K6');
      });
    });

    group('US ZIP', () {
      test('matches 5-digit at end', () {
        expect(addressGroupKey('123 Elm St, Boston MA 02101'),
            'zip:02101');
      });
      test('matches 9-digit ZIP+4 at end', () {
        expect(addressGroupKey('123 Elm St, Boston MA 02101-1234'),
            'zip:02101-1234');
      });
      test('ignores mid-string 5-digit number that is not the ZIP', () {
        expect(addressGroupKey('Suite 12345 Elm St'),
            'addr:suite 12345 elm st');
      });
    });

    group('Singapore postal', () {
      test('matches 6-digit at end', () {
        expect(addressGroupKey('Blk 123 Bukit Timah Rd 123456'),
            'zip:123456');
      });
    });

    test('priority: CA > US > SG', () {
      expect(addressGroupKey('123 Main M5A 1A1 02101'), 'zip:M5A1A1');
    });

    group('fallback (no postal)', () {
      test('lowercases and collapses whitespace', () {
        expect(addressGroupKey('  Main   Street  '),
            'addr:main street');
        expect(addressGroupKey('MAIN STREET'), 'addr:main street');
      });
      test('different addresses stay different', () {
        expect(addressGroupKey('Foo St'),
            isNot(equals(addressGroupKey('Bar St'))));
      });
    });
  });
}
