import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';

/// The bundled pilgrimage background image, full-bleed behind every screen,
/// with a cream scrim so content stays readable. [scrimAlpha] controls the
/// scrim strength — raise it on reading-heavy pages.
class PilgrimBackground extends StatelessWidget {
  const PilgrimBackground({super.key, this.scrimAlpha = 0.15});

  final double scrimAlpha;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.background, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: scrimAlpha),
            ),
          ),
        ],
      ),
    );
  }
}
