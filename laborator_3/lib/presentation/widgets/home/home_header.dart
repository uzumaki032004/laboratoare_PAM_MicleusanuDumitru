import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/json_icon.dart';
import '../../../data/models/models.dart';
import '../common/app_network_image.dart';

/// Antetul portocaliu: salut, notificări, avatar și acțiuni.
class HomeHeaderBar extends StatelessWidget {
  const HomeHeaderBar({
    super.key,
    required this.header,
    required this.onFavorites,
    required this.onNotifications,
    this.menu,
  });

  final HomeHeader header;
  final VoidCallback onFavorites;
  final VoidCallback onNotifications;

  /// Meniul demonstrativ pentru stări (Reload / Simulate error).
  final Widget? menu;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(20, topInset + 16, 8, 64),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  header.greeting,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  header.subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Favorites',
            onPressed: onFavorites,
            icon: const Icon(Icons.favorite_border_rounded),
            color: Colors.white,
          ),
          Stack(
            children: [
              IconButton(
                tooltip: 'Notifications',
                onPressed: onNotifications,
                icon: JsonIcon(header.notificationIconUrl, size: 26),
              ),
              if (header.hasUnreadNotifications)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
          ClipOval(
            child: AppNetworkImage(
              header.avatarUrl,
              width: 44,
              height: 44,
              fallbackIcon: Icons.person_rounded,
            ),
          ),
          if (menu != null) menu!,
        ],
      ),
    );
  }
}
