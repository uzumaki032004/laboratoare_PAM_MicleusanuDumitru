import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

/// Imagine din rețea (URL din JSON) cu fundal în timpul încărcării și
/// pictogramă de rezervă dacă nu există internet.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.fallbackIcon = Icons.image_outlined,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: borderRadius,
    child: Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : _placeholder(null),
      errorBuilder: (context, error, stackTrace) => _placeholder(fallbackIcon),
    ),
  );

  Widget _placeholder(IconData? icon) => Container(
    width: width,
    height: height,
    color: AppColors.border,
    alignment: Alignment.center,
    child: icon == null ? null : Icon(icon, color: AppColors.grey),
  );
}
