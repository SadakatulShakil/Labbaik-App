import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';

/// The bundled pilgrimage background image, full-bleed behind the Home
/// trail, with a light cream scrim so nodes and titles stay readable.
class PilgrimBackground extends StatelessWidget {
  const PilgrimBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.background, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }
}
