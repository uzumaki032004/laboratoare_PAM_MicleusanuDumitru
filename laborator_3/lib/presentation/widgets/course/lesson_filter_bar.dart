import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../logic/lessons/lesson_query.dart';

/// Filtre (ChoiceChip) și meniul de sortare pentru lista de lecții.
class LessonFilterBar extends StatelessWidget {
  const LessonFilterBar({
    super.key,
    required this.filter,
    required this.sort,
    required this.onFilterChanged,
    required this.onSortChanged,
  });

  final LessonFilter filter;
  final LessonSort sort;
  final ValueChanged<LessonFilter> onFilterChanged;
  final ValueChanged<LessonSort> onSortChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final option in LessonFilter.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(option.label),
                    selected: option == filter,
                    onSelected: (_) => onFilterChanged(option),
                    selectedColor: AppColors.primaryLight,
                    labelStyle: TextStyle(
                      color: option == filter
                          ? AppColors.primary
                          : AppColors.dark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      PopupMenuButton<LessonSort>(
        tooltip: 'Sort lessons',
        initialValue: sort,
        onSelected: onSortChanged,
        icon: const Icon(Icons.sort_rounded, color: AppColors.dark),
        itemBuilder: (context) => [
          for (final option in LessonSort.values)
            CheckedPopupMenuItem<LessonSort>(
              value: option,
              checked: option == sort,
              child: Text(option.label),
            ),
        ],
      ),
    ],
  );
}
