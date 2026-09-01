import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/localization/locale_keys.dart';
import '../../widgets/app_scaffold.dart';
import 'story_controller.dart';

/// The story reward screen, shown after completing a chapter that has a
/// story attached — a calm, dignified moment before returning to Home.
class StoryView extends GetView<StoryController> {
  const StoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showHome: true,
      scrimAlpha: 0.5,
      body: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(controller.textScale)),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.paddingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(context),
                    if (controller.ttsEnabled) ...[
                      SizedBox(height: AppDimensions.paddingMd),
                      _buildListenButton(),
                    ],
                    SizedBox(height: AppDimensions.paddingXl),
                    _buildStoryCard(context),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppDimensions.paddingLg),
              child: _buildBottomAction(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final chapterTitle = controller.isBn
        ? controller.chapter.titleBn
        : controller.chapter.titleEn;

    if (controller.isReview) {
      return Text(
        chapterTitle,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium,
      );
    }

    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutBack,
          builder: (context, value, child) => Opacity(
            opacity: value.clamp(0, 1),
            child: Transform.scale(scale: 0.6 + 0.4 * value, child: child),
          ),
          child: Container(
            width: 88.w,
            height: 88.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accentGold,
            ),
            child: Icon(Icons.check, color: AppColors.surface, size: 48.sp),
          ),
        ),
        SizedBox(height: AppDimensions.paddingMd),
        Obx(() {
          if (controller.isLastChapter.value) {
            return Column(
              children: [
                Text(
                  Keys.journeyDone
                      .trParams({'journey': controller.journeyTitleKey.tr}),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                // TODO Phase 8: add the du'a for a Hajj/Umrah Mabrur here.
              ],
            );
          }

          return Column(
            children: [
              Text(
                Keys.completedExclaim.tr,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: AppDimensions.paddingSm),
              Text(
                chapterTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildStoryCard(BuildContext context) {
    final story = controller.story!;
    final storyTitle = controller.isBn ? story.titleBn : story.titleEn;
    final storyBody = controller.isBn ? story.bodyBn : story.bodyEn;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            storyTitle,
            key: controller.titleKey,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (story.imageAsset != null) ...[
            SizedBox(height: AppDimensions.paddingMd),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              child: Image.asset(story.imageAsset!, fit: BoxFit.cover),
            ),
          ],
          SizedBox(height: AppDimensions.paddingMd),
          Text(
            storyBody,
            key: controller.bodyKey,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildListenButton() {
    return Obx(() {
      final narrating = controller.isNarrating.value;
      return OutlinedButton.icon(
        onPressed:
            narrating ? controller.stopNarration : controller.narrateStory,
        icon: Icon(narrating ? Icons.stop_circle : Icons.play_circle_fill),
        label: Text(narrating ? Keys.stop.tr : Keys.listen.tr),
      );
    });
  }

  Widget _buildBottomAction(BuildContext context) {
    if (controller.isReview) {
      return ElevatedButton(
        onPressed: controller.dismiss,
        child: Text(Keys.back.tr),
      );
    }

    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!controller.isLastChapter.value) ...[
            Text(
              Keys.nextUnlocked.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: AppDimensions.paddingMd),
          ],
          ElevatedButton(
            onPressed: controller.dismiss,
            child: Text(Keys.continueBtn.tr),
          ),
        ],
      );
    });
  }
}
