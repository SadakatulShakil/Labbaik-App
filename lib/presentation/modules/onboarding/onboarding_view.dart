import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/localization/locale_keys.dart';
import '../../widgets/app_scaffold.dart';
import 'onboarding_controller.dart';

class _Slide {
  const _Slide({required this.icon, required this.titleKey, required this.bodyKey});

  final IconData icon;
  final String titleKey;
  final String bodyKey;
}

const _slides = [
  _Slide(
    icon: Icons.volunteer_activism,
    titleKey: Keys.onbTitle1,
    bodyKey: Keys.onbBody1,
  ),
  _Slide(
    icon: Icons.format_list_numbered,
    titleKey: Keys.onbTitle2,
    bodyKey: Keys.onbBody2,
  ),
  _Slide(
    icon: Icons.wifi_off,
    titleKey: Keys.onbTitle3,
    bodyKey: Keys.onbBody3,
  ),
];

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Obx(
              () => Opacity(
                opacity: controller.currentPage.value < _slides.length - 1 ? 1 : 0,
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingMd),
                  child: TextButton(
                    onPressed: controller.currentPage.value < _slides.length - 1
                        ? controller.skip
                        : null,
                    child: Text(
                      Keys.skip.tr,
                      style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: _slides.length,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (context, index) => _SlideContent(slide: _slides[index]),
            ),
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                final active = controller.currentPage.value == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: active ? 24.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: active ? AppColors.accentGold : AppColors.locked,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppDimensions.paddingLg),
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.next,
                child: Text(
                  controller.currentPage.value == _slides.length - 1
                      ? Keys.getStarted.tr
                      : Keys.next.tr,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideContent extends StatelessWidget {
  const _SlideContent({required this.slide});

  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140.w,
            height: 140.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
              border: Border.all(color: AppColors.accentGold, width: 2),
            ),
            child: Icon(slide.icon, size: 64.sp, color: AppColors.primary),
          ),
          SizedBox(height: AppDimensions.paddingXl),
          Text(
            slide.titleKey.tr,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.paddingMd),
          Text(
            slide.bodyKey.tr,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
