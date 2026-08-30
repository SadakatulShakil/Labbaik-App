import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings_keys.dart';
import '../../core/utils/icon_from_name.dart';
import '../../domain/entities/chapter_content.dart';
import '../modules/home/chapter_state.dart';

/// One node on the Home chapter path: a large circular badge plus title,
/// colored by [state], with a short connector line to the next node.
class ChapterNode extends StatelessWidget {
  const ChapterNode({
    super.key,
    required this.chapter,
    required this.state,
    required this.isCurrent,
    required this.onTap,
    this.showConnector = true,
  });

  final ChapterContent chapter;
  final ChapterState state;
  final bool isCurrent;
  final VoidCallback onTap;
  final bool showConnector;

  static const _badgeSize = 68.0;

  Color get _badgeColor {
    switch (state) {
      case ChapterState.locked:
        return AppColors.locked;
      case ChapterState.unlocked:
        return AppColors.primary;
      case ChapterState.completed:
        return AppColors.accentGold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = (Get.locale?.languageCode ?? 'bn') == 'bn';
    final title = isBn ? chapter.titleBn : chapter.titleEn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildBadge(),
                SizedBox(width: AppDimensions.paddingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: state == ChapterState.locked
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                            ),
                      ),
                      if (isCurrent) ...[
                        SizedBox(height: 4.h),
                        _buildStartHerePill(),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showConnector)
          Padding(
            padding: EdgeInsets.only(left: (_badgeSize.w / 2) - 1.5.w),
            child: Container(
              width: 3.w,
              height: AppDimensions.paddingLg,
              color: state == ChapterState.completed
                  ? AppColors.accentGold
                  : AppColors.divider,
            ),
          ),
      ],
    );
  }

  Widget _buildBadge() {
    return SizedBox(
      width: _badgeSize.w,
      height: _badgeSize.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _badgeColor,
              border: state == ChapterState.unlocked
                  ? Border.all(color: AppColors.accentGold, width: 2.5)
                  : null,
            ),
            child: Icon(
              iconFromName(chapter.icon),
              color: AppColors.surface,
              size: 30.sp,
            ),
          ),
          if (state == ChapterState.locked)
            Positioned(
              right: -2,
              bottom: -2,
              child: _buildOverlayDot(Icons.lock, AppColors.textSecondary),
            ),
          if (state == ChapterState.completed)
            Positioned(
              right: -2,
              bottom: -2,
              child: _buildOverlayDot(Icons.check, AppColors.success),
            ),
        ],
      ),
    );
  }

  Widget _buildOverlayDot(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.all(color: color, width: 1.5),
      ),
      child: Icon(icon, size: 14.sp, color: color),
    );
  }

  Widget _buildStartHerePill() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.accentGold,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Text(
        Keys.startHere.tr,
        style: TextStyle(
          color: AppColors.surface,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
