import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

/// Bară de progres rotunjită, folosită pe ecranul principal și în curs.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.height = 6,
    this.color = AppColors.primary,
    this.backgroundColor = AppColors.primaryLight,
  });

  final double value;
  final double height;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(height),
    child: LinearProgressIndicator(
      value: value.clamp(0.0, 1.0),
      minHeight: height,
      color: color,
      backgroundColor: backgroundColor,
    ),
  );
}
