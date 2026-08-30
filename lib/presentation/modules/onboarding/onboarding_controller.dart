import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';

class OnboardingController extends GetxController {
  static const totalPages = 3;

  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  void onPageChanged(int index) => currentPage.value = index;

  void next() {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      finish();
    }
  }

  void skip() => finish();

  void finish() => Get.offNamed(Routes.journeySelect);

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
