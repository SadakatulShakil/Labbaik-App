import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings_keys.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/to_local_digits.dart';
import '../../../domain/entities/chapter_content.dart';
import '../../widgets/chapter_path_view.dart';
import '../../widgets/pilgrim_background.dart';
import 'chapter_state.dart';
import 'home_controller.dart';

/// The chapter path — a locked-level "hazard levels" style progression
/// through a journey's chapters, grouped by phase.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() => Text(controller.journeyTitleKey.tr)),
        actions: [
          // TODO Phase 7: wire to Settings.
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.paddingMd,
                AppDimensions.paddingMd,
                AppDimensions.paddingMd,
                0,
              ),
              child: _buildJourneyToggle(),
            ),
            Padding(
              padding: EdgeInsets.all(AppDimensions.paddingMd),
              child: _buildProgressRow(context),
            ),
            Expanded(
              child: Stack(
                children: [
                  const PilgrimBackground(),
                  ChapterPathView(
                    chapters: controller.chapters,
                    stateOf: controller.stateOf,
                    isCurrent: controller.isCurrent,
                    onChapterTap: _onChapterTap,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildJourneyToggle() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPill(
              Keys.umrah.tr,
              controller.journey.value == 'umrah',
              () => controller.switchJourney('umrah'),
            ),
          ),
          Expanded(
            child: _buildPill(
              Keys.hajj.tr,
              controller.journey.value == 'hajj',
              () => controller.switchJourney('hajj'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSm),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.surface : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: AppDimensions.bodyFontSize,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressRow(BuildContext context) {
    final lang = Get.locale?.languageCode ?? 'bn';
    final countText =
        '${toLocalDigits('${controller.completedCount}', lang)}/'
        '${toLocalDigits('${controller.total}', lang)} ${Keys.completed.tr}';
    final ratio = controller.total == 0
        ? 0.0
        : controller.completedCount / controller.total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(countText, style: Theme.of(context).textTheme.bodyLarge),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 10.h,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.accentGold),
          ),
        ),
      ],
    );
  }

  Future<void> _onChapterTap(ChapterContent chapter, ChapterState state) async {
    if (state == ChapterState.locked) {
      Get.snackbar(
        '',
        Keys.lockedHint.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.textPrimary,
        colorText: AppColors.surface,
        margin: EdgeInsets.all(AppDimensions.paddingMd),
        borderRadius: AppDimensions.radiusMd,
      );
      return;
    }

    await Get.toNamed(Routes.chapter, arguments: chapter);
    controller.load();
  }
}
