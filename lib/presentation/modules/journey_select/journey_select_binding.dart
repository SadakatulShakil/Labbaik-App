import 'package:get/get.dart';

import 'journey_select_controller.dart';

class JourneySelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JourneySelectController>(() => JourneySelectController());
  }
}
