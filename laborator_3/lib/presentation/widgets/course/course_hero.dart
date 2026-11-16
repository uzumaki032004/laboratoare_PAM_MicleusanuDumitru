import 'package:flutter/material.dart';

import '../../../core/json_icon.dart';
import '../../../data/models/models.dart';
import '../common/app_network_image.dart';

/// Imaginea mare a cursului, cu eticheta și butonul Play.
class CourseHero extends StatelessWidget {
  const CourseHero({super.key, required this.hero, required this.onPlay});

  final CourseHeroData hero;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 200,
    child: Stack(
      fit: StackFit.expand,
      children: [
        AppNetworkImage(hero.imageUrl, borderRadius: BorderRadius.circular(20)),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x33000000), Color(0x99000000)],
            ),
          ),
        ),
        Positioned(
          left: 16,
          top: 16,
          child: Text(
            hero.label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Center(
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPlay,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: JsonIcon(hero.playIconUrl, size: 34),
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: 14,
          child: Text(
            '${hero.videoCount} videos · ${hero.classCount} classes',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
