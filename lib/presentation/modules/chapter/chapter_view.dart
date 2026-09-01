import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/localization/locale_keys.dart';
import '../../../core/utils/icon_from_name.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/dua_card.dart';
import 'chapter_controller.dart';

class ChapterView extends GetView<ChapterController> {
  const ChapterView({super.key});

  @override
  Widget build(BuildContext context) {
    final title =
        controller.isBn ? controller.chapter.titleBn : controller.chapter.titleEn;

    return AppScaffold(
      title: Text(title),
      showBack: true,
      showHome: true,
      scrimAlpha: 0.7,
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
                    SizedBox(height: AppDimensions.paddingXl),
                    _buildReadingBlocks(context),
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
    final title = controller.isBn
        ? controller.chapter.titleBn
        : controller.chapter.titleEn;

    return Column(
      children: [
        Obx(
          () => Container(
            width: 88.w,
            height: 88.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.isCompleted.value
                  ? AppColors.accentGold
                  : AppColors.primary,
            ),
            child: Image.asset(
              'assets/images/chapters/${controller.chapter.id}.png',
              width: 56.w, height: 56.w,
              errorBuilder: (_, __, ___) => Icon(iconFromName(controller.chapter.icon)), // fallback
            )
          ),
        ),
        SizedBox(height: AppDimensions.paddingMd),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        if (controller.ttsEnabled) ...[
          SizedBox(height: AppDimensions.paddingMd),
          _buildListenButton(),
        ],
      ],
    );
  }

  Widget _buildListenButton() {
    return Obx(() {
      final narrating = controller.isNarrating.value;
      return OutlinedButton.icon(
        onPressed: narrating ? controller.stopNarration : controller.narrateChapter,
        icon: Icon(narrating ? Icons.stop_circle : Icons.play_circle_fill),
        label: Text(narrating ? Keys.stop.tr : Keys.listen.tr),
      );
    });
  }

  /// Renders every [ReadingBlock] in order, each wrapped in its own key so
  /// [ChapterController.narrateChapter] can auto-scroll to it. The gap after
  /// each block mirrors the spacing the old per-section builders used.
  Widget _buildReadingBlocks(BuildContext context) {
    final blocks = controller.blocks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < blocks.length; i++) ...[
          KeyedSubtree(
            key: blocks[i].key,
            child: _buildBlockContent(context, blocks[i]),
          ),
          SizedBox(
            height: _gapAfter(
              blocks[i],
              i + 1 < blocks.length ? blocks[i + 1] : null,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBlockContent(BuildContext context, ReadingBlock block) {
    switch (block.kind) {
      case ReadingKind.sectionHeader:
      case ReadingKind.duaHeader:
        return Text(block.text!, style: Theme.of(context).textTheme.titleLarge);
      case ReadingKind.plainBody:
        return _buildPlainCard(context, block.text!);
      case ReadingKind.step:
        return _buildStepCard(context, block.stepNumber!, block.text!);
      case ReadingKind.tip:
        return _buildTipCallout(context, block.text!);
      case ReadingKind.dua:
        return DuaCard(dua: block.dua!, isBn: controller.isBn);
    }
  }

  double _gapAfter(ReadingBlock current, ReadingBlock? next) {
    switch (current.kind) {
      case ReadingKind.sectionHeader:
      case ReadingKind.duaHeader:
        return AppDimensions.paddingSm;
      case ReadingKind.step:
        return next?.kind == ReadingKind.step
            ? AppDimensions.paddingSm
            : AppDimensions.paddingLg;
      case ReadingKind.plainBody:
      case ReadingKind.tip:
        return AppDimensions.paddingLg;
      case ReadingKind.dua:
        return AppDimensions.paddingSm;
    }
  }

  Widget _buildPlainCard(BuildContext context, String body) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(body, style: Theme.of(context).textTheme.bodyLarge),
    );
  }

  Widget _buildStepCard(BuildContext context, int number, String text) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: Text(
              '$number',
              style: TextStyle(
                color: AppColors.surface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: AppDimensions.paddingMd),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCallout(BuildContext context, String body) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.accentGold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.accentGold),
          SizedBox(width: AppDimensions.paddingSm),
          Expanded(
            child: Text(body, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Obx(() {
      if (controller.isCompleted.value) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: AppColors.success),
                SizedBox(width: AppDimensions.paddingSm),
                Text(
                  Keys.alreadyDone.tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            if (controller.chapter.story != null) ...[
              SizedBox(height: AppDimensions.paddingMd),
              OutlinedButton(
                onPressed: controller.openStoryReview,
                child: Text(Keys.viewStory.tr),
              ),
            ],
          ],
        );
      }

      return ElevatedButton(
        onPressed: controller.complete,
        child: Text(Keys.markComplete.tr),
      );
    });
  }
}
