import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../data/models/models.dart';

/// Comutator între tab-urile din JSON („Lessons” / „Description”).
class CourseTabs extends StatelessWidget {
  const CourseTabs({
    super.key,
    required this.tabs,
    required this.selectedId,
    required this.onSelected,
  });

  final List<CourseTab> tabs;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: AppColors.border,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        for (final tab in tabs)
          Expanded(
            child: _TabButton(
              label: tab.label,
              selected: tab.id == selectedId,
              onTap: () => onSelected(tab.id),
            ),
          ),
      ],
    ),
  );
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    child: Material(
      color: selected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.primary : AppColors.grey,
            ),
          ),
        ),
      ),
    ),
  );
}
