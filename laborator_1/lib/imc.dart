/// Interpretarea folosește pragurile IMC pentru adulți.
enum ImcCategory {
  underweight('Subponderal'),
  normal('Normal'),
  overweight('Supraponderal'),
  obesity1('Obezitate grad I'),
  obesity2('Obezitate grad II'),
  obesity3('Obezitate grad III');

  const ImcCategory(this.label);
  final String label;
}

class ImcResult {
  const ImcResult(this.value, this.category);
  final double value;
  final ImcCategory category;
}

double? parseMeasurement(String input) {
  final normalized = input.trim().replaceAll(',', '.');
  if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(normalized)) return null;
  final value = double.tryParse(normalized);
  return value != null && value.isFinite && value > 0 ? value : null;
}

ImcResult calculateImc(double weightKg, double heightCm) {
  if (!weightKg.isFinite ||
      !heightCm.isFinite ||
      weightKg <= 0 ||
      heightCm <= 0) {
    throw ArgumentError('Greutatea și înălțimea trebuie să fie pozitive.');
  }
  final heightM = heightCm / 100;
  final value = weightKg / (heightM * heightM);
  if (!value.isFinite || value <= 0) {
    throw ArgumentError('Valorile sunt prea mari sau prea mici pentru calcul.');
  }
  final category = switch (value) {
    < 18.5 => ImcCategory.underweight,
    < 25 => ImcCategory.normal,
    < 30 => ImcCategory.overweight,
    < 35 => ImcCategory.obesity1,
    < 40 => ImcCategory.obesity2,
    _ => ImcCategory.obesity3,
  };
  return ImcResult(value, category);
}
