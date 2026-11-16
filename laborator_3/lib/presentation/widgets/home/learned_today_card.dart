import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../data/models/models.dart';
import '../common/app_progress_bar.dart';

/// Cardul „Learned today” cu minutele învățate și progresul zilei.
class LearnedTodayCard extends StatelessWidget {
  const LearnedTodayCard({
    super.key,
    required this.data,
    required this.actionLabel,
    required this.onAction,
  });

  final LearnedToday data;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(18, 8, 8, 18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A101012),
          blurRadius: 18,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                data.title,
                style: const TextStyle(color: AppColors.grey),
              ),
            ),
            TextButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
        Semantics(
          label: data.formatted,
          child: ExcludeSemantics(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${data.learnedMinutes}min',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.dark,
                    ),
                  ),
                  TextSpan(
                    text: ' / ${data.goalMinutes}min',
                    style: const TextStyle(color: AppColors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: AppProgressBar(value: data.progress),
        ),
      ],
    ),
  );
}
