import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/localization/locale_keys.dart';
import '../../widgets/selection_card.dart';
import 'language_controller.dart';

class LanguageView extends GetView<LanguageController> {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(Keys.selectLanguage.tr)),
      body: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppDimensions.paddingLg),
            SelectionCard(
              title: Keys.bangla.tr,
              highlighted: true,
              leading: Text('বা', style: TextStyle(fontSize: 28.sp, color: AppColors.primary)),
              onTap: () => controller.selectLanguage('bn'),
            ),
            SizedBox(height: AppDimensions.paddingMd),
            SelectionCard(
              title: Keys.english.tr,
              leading: Text('En', style: TextStyle(fontSize: 24.sp, color: AppColors.primary)),
              onTap: () => controller.selectLanguage('en'),
            ),
          ],
        ),
      ),
    );
  }
}
