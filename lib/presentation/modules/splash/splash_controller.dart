import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';

/// Waits briefly on the branded splash, then routes to the first-run flow
/// or straight to home depending on [StorageService.isFirstLaunch].
class SplashController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  @override
  void onReady() {
    super.onReady();
    _decideNextRoute();
  }

  Future<void> _decideNextRoute() async {
    await Future.delayed(const Duration(seconds: 2));

    if (_storage.isFirstLaunch) {
      Get.offAllNamed(Routes.language);
      return;
    }

    final code = _storage.languageCode;
    if (code != null) {
      Get.updateLocale(Locale(code));
    }
    Get.offAllNamed(Routes.home);
  }
}
