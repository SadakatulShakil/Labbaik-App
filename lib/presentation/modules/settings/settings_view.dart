import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/localization/locale_keys.dart';
import '../../widgets/app_scaffold.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  static const _sizeOptions = [
    (0.9, Keys.sizeSmall),
    (1.0, Keys.sizeMedium),
    (1.2, Keys.sizeLarge),
    (1.4, Keys.sizeXLarge),
  ];

  static const _speedOptions = [
    (0.35, Keys.speedSlow),
    (0.5, Keys.speedNormal),
    (0.65, Keys.speedFast),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(Keys.settings.tr),
      showBack: true,
      scrimAlpha: 0.5,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLanguageCard(context),
            SizedBox(height: AppDimensions.paddingMd),
            _buildTextSizeCard(context),
            SizedBox(height: AppDimensions.paddingMd),
            _buildAudioCard(context),
            SizedBox(height: AppDimensions.paddingMd),
            _buildResetCard(context),
            SizedBox(height: AppDimensions.paddingMd),
            _buildAboutCard(context),
          ],
        ),
      ),
    );
  }

  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.divider),
      ),
      child: child,
    );
  }

  Widget _buildLanguageCard(BuildContext context) {
    return _card(
      InkWell(
        onTap: controller.openLanguage,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Row(
          children: [
            Expanded(
              child: Text(
                Keys.language.tr,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Text(
              controller.currentLanguageLabel,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(width: AppDimensions.paddingSm),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSizeCard(BuildContext context) {
    return _card(
      Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              Keys.textSize.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: AppDimensions.paddingSm),
            Row(
              children: [
                for (final option in _sizeOptions)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: _segmentButton(
                        label: option.$2.tr,
                        active: controller.textScale.value == option.$1,
                        onTap: () => controller.setTextScale(option.$1),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: AppDimensions.paddingMd),
            Text(Keys.preview.tr, style: Theme.of(context).textTheme.labelLarge),
            SizedBox(height: 4.h),
            Text(
              'সালামুন আলাইকুম — Peace be upon you',
              style: TextStyle(
                fontSize: AppDimensions.bodyFontSize * controller.textScale.value,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioCard(BuildContext context) {
    return _card(
      Obx(() {
        final enabled = controller.ttsEnabled.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    Keys.audioNarration.tr,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Switch(
                  value: enabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: controller.toggleTts,
                ),
              ],
            ),
            if (enabled) ...[
              SizedBox(height: AppDimensions.paddingMd),
              Text(Keys.speed.tr, style: Theme.of(context).textTheme.labelLarge),
              SizedBox(height: AppDimensions.paddingSm),
              Row(
                children: [
                  for (final option in _speedOptions)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: _segmentButton(
                          label: option.$2.tr,
                          active: controller.ttsSpeed.value == option.$1,
                          onTap: () => controller.setTtsSpeed(option.$1),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: AppDimensions.paddingMd),
              OutlinedButton.icon(
                onPressed: controller.testTts,
                icon: const Icon(Icons.play_circle_fill),
                label: Text(Keys.test.tr),
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _segmentButton({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSm),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? AppColors.surface : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildResetCard(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return _card(
      InkWell(
        onTap: () => _confirmReset(context),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Row(
          children: [
            Icon(Icons.restart_alt, color: errorColor),
            SizedBox(width: AppDimensions.paddingSm),
            Expanded(
              child: Text(
                Keys.resetProgress
                    .trParams({'journey': controller.currentJourneyLabel}),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: errorColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    Get.defaultDialog(
      title: Keys.resetConfirmTitle.tr,
      middleText: Keys.resetConfirmBody.tr,
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back();
          await controller.resetCurrentJourney();
          Get.snackbar(
            '',
            Keys.resetDone.trParams({'journey': controller.currentJourneyLabel}),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.textPrimary,
            colorText: AppColors.surface,
            margin: EdgeInsets.all(AppDimensions.paddingMd),
            borderRadius: AppDimensions.radiusMd,
          );
        },
        child: Text(Keys.reset.tr),
      ),
      cancel: OutlinedButton(
        onPressed: Get.back,
        child: Text(Keys.cancel.tr),
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Keys.about.tr, style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: AppDimensions.paddingMd),
          Text(
            Keys.appName.tr,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          // TODO: wire package_info later.
          Text(
            'v1.0.0',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimensions.paddingSm),
          Text(Keys.appTagline.tr, style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: AppDimensions.paddingSm),
          Text(
            '${Keys.developedBy.tr}: SAM Techno BD',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimensions.paddingMd),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimensions.paddingSm),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.4)),
            ),
            child: Text(
              Keys.disclaimer.tr,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
