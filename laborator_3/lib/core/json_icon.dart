import 'package:flutter/material.dart';

/// Afișează o pictogramă descrisă în JSON printr-un URL Iconify, de exemplu
/// `https://api.iconify.design/mdi/play.svg?color=%23FF6F00&width=38`.
///
/// Din URL se citesc numele pictogramei și culoarea, iar pictograma este
/// desenată cu echivalentul Material. Astfel aplicația funcționează și fără
/// internet, dar respectă culorile din fișierul de date.
class JsonIcon extends StatelessWidget {
  const JsonIcon(this.url, {super.key, this.size, this.color});

  final String url;
  final double? size;

  /// Dacă este setată, înlocuiește culoarea din URL.
  final Color? color;

  static const _icons = <String, IconData>{
    'bell-outline': Icons.notifications_none_rounded,
    'progress-check': Icons.task_alt_rounded,
    'progress-clock': Icons.timelapse_rounded,
    'arrow-left': Icons.arrow_back_rounded,
    'play': Icons.play_arrow_rounded,
    'play-circle-outline': Icons.play_circle_outline_rounded,
    'chevron-right': Icons.chevron_right_rounded,
    'clock-outline': Icons.schedule_rounded,
    'book-open-outline': Icons.menu_book_outlined,
    'star': Icons.star_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(url);
    final segments = uri?.pathSegments ?? const <String>[];
    final name = segments.isEmpty ? '' : segments.last.replaceAll('.svg', '');
    final params = uri?.queryParameters ?? const <String, String>{};
    final width = double.tryParse(params['width'] ?? '');
    return Icon(
      _icons[name] ?? Icons.circle_outlined,
      size: size ?? width ?? 24,
      color: color ?? parseHexColor(params['color']),
    );
  }

  /// `#FF6F00` -> `Color(0xFFFF6F00)`; întoarce `null` pentru valori invalide.
  static Color? parseHexColor(String? value) {
    if (value == null) return null;
    final hex = value.replaceFirst('#', '');
    if (hex.length != 6) return null;
    final parsed = int.tryParse(hex, radix: 16);
    return parsed == null ? null : Color(0xFF000000 | parsed);
  }
}
