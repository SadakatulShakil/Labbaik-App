import 'package:get/get.dart';

import '../services/storage_service.dart';

/// Registers app-wide singletons available for the lifetime of the app.
/// Add further shared services here as phases land.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StorageService>(StorageService(), permanent: true);
  }
}
