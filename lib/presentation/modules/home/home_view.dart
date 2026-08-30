import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import 'home_controller.dart';

/// Placeholder Home so the first-run flow lands somewhere real and
/// testable. Real Home lands in Phase 4.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(controller.journeyTitleKey.tr),
        actions: [
          // TODO: wire to Settings in Phase 7
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.journeyTitleKey.tr,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 12.h),
            Text(
              'Home — coming in Phase 4',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
