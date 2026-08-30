import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/localization/locale_keys.dart';
import '../../widgets/selection_card.dart';
import 'journey_select_controller.dart';

class JourneySelectView extends GetView<JourneySelectController> {
  const JourneySelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(Keys.selectJourney.tr)),
      body: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppDimensions.paddingLg),
            SelectionCard(
              title: Keys.umrah.tr,
              subtitle: Keys.umrahDesc.tr,
              // TODO: real Kaaba/crescent illustrations
              leading: Icon(Icons.brightness_3, size: 36.sp, color: AppColors.primary),
              onTap: () => controller.selectJourney('umrah'),
            ),
            SizedBox(height: AppDimensions.paddingMd),
            SelectionCard(
              title: Keys.hajj.tr,
              subtitle: Keys.hajjDesc.tr,
              // TODO: real Kaaba/crescent illustrations
              leading: Icon(Icons.location_city, size: 36.sp, color: AppColors.primary),
              onTap: () => controller.selectJourney('hajj'),
            ),
          ],
        ),
      ),
    );
  }
}
