import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../common/app_network_image.dart';

/// Card cu text în stânga și imagine în dreapta.
/// Este refolosit pentru „What do you want to learn today?” și „Meetup”.
class PromoCard extends StatelessWidget {
  const PromoCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.backgroundColor,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String imageUrl;
  final Color backgroundColor;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.dark,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  style: const TextStyle(color: AppColors.greyIcon),
                ),
              ],
              if (actionLabel != null) ...[
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: onAction,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                  child: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        AppNetworkImage(
          imageUrl,
          width: 104,
          height: 104,
          borderRadius: BorderRadius.circular(14),
        ),
      ],
    ),
  );
}
