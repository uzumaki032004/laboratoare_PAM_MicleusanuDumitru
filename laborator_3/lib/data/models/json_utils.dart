/// Funcții ajutătoare pentru citirea sigură a valorilor din JSON.
///
/// Dacă un câmp lipsește sau are alt tip, se aruncă [FormatException],
/// iar Cubit-ul transformă excepția în starea Error.
library;

T readValue<T>(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is T) return value;
  throw FormatException(
    'Câmpul "$key" lipsește sau are un tip greșit (se aștepta $T).',
  );
}

double readDouble(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is num) return value.toDouble();
  throw FormatException('Câmpul "$key" trebuie să fie un număr.');
}

Map<String, dynamic> readMap(Map<String, dynamic> json, String key) =>
    readValue<Map<String, dynamic>>(json, key);

List<Map<String, dynamic>> readMapList(Map<String, dynamic> json, String key) {
  final list = readValue<List<dynamic>>(json, key);
  final result = <Map<String, dynamic>>[];
  for (final item in list) {
    if (item is! Map<String, dynamic>) {
      throw FormatException('Lista "$key" conține un element invalid.');
    }
    result.add(item);
  }
  return result;
}
