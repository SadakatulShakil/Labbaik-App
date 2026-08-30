import 'package:get/get.dart';

import '../../../core/constants/app_strings_keys.dart';
import '../../../core/services/storage_service.dart';

/// Placeholder controller for Phase 2. Real Home lands in Phase 4.
class HomeController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  String get journeyTitleKey =>
      _storage.selectedJourney == 'hajj' ? Keys.hajj : Keys.umrah;
}
