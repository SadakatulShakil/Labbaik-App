import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/localization/locale_keys.dart';
import '../../../core/utils/icon_from_name.dart';
import '../../../domain/entities/content_section.dart';
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
                    _buildSections(context),
                    _buildDuas(context),
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
            child: Icon(
              iconFromName(controller.chapter.icon),
              color: AppColors.surface,
              size: 40.sp,
            ),
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

  Widget _buildSections(BuildContext context) {
    final sections = [...controller.chapter.sections]
      ..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final section in sections) ...[
          _buildSectionHeader(context, section.type),
          SizedBox(height: AppDimensions.paddingSm),
          _buildSectionBody(context, section),
          SizedBox(height: AppDimensions.paddingLg),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String type) {
    final key = switch (type) {
      'intro' => Keys.sectionInShort,
      'steps' => Keys.sectionSteps,
      'tip' => Keys.sectionTips,
      _ => Keys.sectionInShort,
    };
    return Text(key.tr, style: Theme.of(context).textTheme.titleLarge);
  }

  Widget _buildSectionBody(BuildContext context, ContentSection section) {
    final body = controller.isBn ? section.bodyBn : section.bodyEn;

    if (section.type == 'tip') {
      return _buildTipCallout(context, body);
    }

    if (section.type == 'steps' && body.contains('\n')) {
      final steps = body
          .split('\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            _buildStepCard(context, i + 1, steps[i]),
            if (i != steps.length - 1) SizedBox(height: AppDimensions.paddingSm),
          ],
        ],
      );
    }

    return _buildPlainCard(context, body);
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

  Widget _buildDuas(BuildContext context) {
    if (controller.chapter.duas.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Keys.sectionDuas.tr, style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: AppDimensions.paddingSm),
        for (final dua in controller.chapter.duas) ...[
          DuaCard(dua: dua, isBn: controller.isBn),
          SizedBox(height: AppDimensions.paddingSm),
        ],
      ],
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
            SizedBox(height: AppDimensions.paddingMd),
            OutlinedButton(
              onPressed: Get.back,
              child: Text(Keys.review.tr),
            ),
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
