import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/json_icon.dart';
import '../../../data/models/models.dart';
import '../common/app_progress_bar.dart';
import '../common/section_header.dart';
import '../common/state_views.dart';

/// Secțiunea „Learning Plan”. Dacă lista este goală, afișează starea Empty.
class LearningPlanCard extends StatelessWidget {
  const LearningPlanCard({super.key, required this.plan});

  final LearningPlan plan;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionHeader(title: plan.title),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: plan.items.isEmpty
            ? const EmptyView(
                icon: Icons.event_note_outlined,
                title: 'Your plan is empty',
                message: 'Courses you start will appear here.',
              )
            : Column(
                children: [
                  for (var i = 0; i < plan.items.length; i++) ...[
                    if (i > 0) const SizedBox(height: 18),
                    LearningPlanTile(item: plan.items[i]),
                  ],
                ],
              ),
      ),
    ],
  );
}

/// Un rând din planul de învățare, cu progresul `completed / total`.
class LearningPlanTile extends StatelessWidget {
  const LearningPlanTile({super.key, required this.item});

  final LearningPlanItem item;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          JsonIcon(item.progressIconUrl, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.dark,
              ),
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${item.completed}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.dark,
                  ),
                ),
                TextSpan(
                  text: '/${item.total}',
                  style: const TextStyle(color: AppColors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      AppProgressBar(value: item.progress, height: 4),
    ],
  );
}
