import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

/// Câmp de căutare. Își păstrează textul local (controller) și anunță
/// fiecare modificare prin [onChanged], care apelează Cubit-ul.
class LessonSearchBar extends StatefulWidget {
  const LessonSearchBar({
    super.key,
    required this.initialQuery,
    required this.onChanged,
  });

  final String initialQuery;
  final ValueChanged<String> onChanged;

  @override
  State<LessonSearchBar> createState() => _LessonSearchBarState();
}

class _LessonSearchBarState extends State<LessonSearchBar> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialQuery,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _controller,
    onChanged: widget.onChanged,
    textInputAction: TextInputAction.search,
    decoration: InputDecoration(
      hintText: 'Search lessons',
      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.grey),
      suffixIcon: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _controller,
        builder: (context, value, _) => value.text.isEmpty
            ? const SizedBox.shrink()
            : IconButton(
                tooltip: 'Clear search',
                onPressed: _clear,
                icon: const Icon(Icons.close_rounded),
              ),
      ),
    ),
  );
}
