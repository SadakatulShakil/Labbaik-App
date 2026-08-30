import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';

/// Handles language selection. When opened from Settings (Phase 7) with
/// `Get.arguments == true`, selecting a language just pops back instead of
/// continuing the first-run flow.
class LanguageController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  late final bool fromSettings = Get.arguments == true;

  Future<void> selectLanguage(String code) async {
    await _storage.setLanguageCode(code);
    Get.updateLocale(Locale(code));

    if (fromSettings) {
      Get.back();
    } else {
      Get.toNamed(Routes.onboarding);
    }
  }
}
