import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../data/models/models.dart';

/// Bara de jos a paginii cursului: prețul și butonul „Enroll Now”.
class EnrollBar extends StatelessWidget {
  const EnrollBar({
    super.key,
    required this.price,
    required this.enroll,
    required this.enrolled,
    required this.onEnroll,
  });

  final Price price;
  final EnrollAction enroll;
  final bool enrolled;
  final VoidCallback onEnroll;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color(0x14101012),
          blurRadius: 16,
          offset: Offset(0, -4),
        ),
      ],
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price',
                  style: TextStyle(color: AppColors.grey, fontSize: 12),
                ),
                Text(
                  price.label,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: FilledButton(
                onPressed: enroll.enabled && !enrolled ? onEnroll : null,
                child: Text(enrolled ? 'Enrolled' : enroll.label),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
