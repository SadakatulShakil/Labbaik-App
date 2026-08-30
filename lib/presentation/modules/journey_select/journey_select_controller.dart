import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';

class JourneySelectController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  Future<void> selectJourney(String journey) async {
    await _storage.setSelectedJourney(journey);
    await _storage.setFirstLaunchDone();
    Get.offAllNamed(Routes.home);
  }
}
