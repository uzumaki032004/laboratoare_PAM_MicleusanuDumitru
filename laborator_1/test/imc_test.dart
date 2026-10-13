import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_imc/imc.dart';

void main() {
  test('convertește cm în m înainte de calcul', () {
    final result = calculateImc(70, 175);
    expect(result.value, closeTo(22.857142857, 0.000001));
    expect(result.category, ImcCategory.normal);
  });

  test('clasifică exact pragurile, fără rotunjire înainte de clasificare', () {
    final cases = <double, ImcCategory>{
      18.49: ImcCategory.underweight,
      18.5: ImcCategory.normal,
      24.999: ImcCategory.normal,
      25: ImcCategory.overweight,
      29.999: ImcCategory.overweight,
      30: ImcCategory.obesity1,
      35: ImcCategory.obesity2,
      40: ImcCategory.obesity3,
    };
    for (final entry in cases.entries) {
      expect(calculateImc(entry.key, 100).category, entry.value);
    }
  });

  test('acceptă virgulă, punct și spații exterioare', () {
    expect(parseMeasurement(' 70,5 '), 70.5);
    expect(parseMeasurement('175.5'), 175.5);
  });

  test('respinge datele nevalide', () {
    for (final input in ['', 'abc', '0', '-1', 'NaN', 'Infinity', '1,2,3']) {
      expect(parseMeasurement(input), isNull);
    }
    expect(() => calculateImc(70, 0), throwsArgumentError);
    expect(() => calculateImc(double.infinity, 175), throwsArgumentError);
  });
}
