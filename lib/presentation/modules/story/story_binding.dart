import 'package:get/get.dart';

import 'story_controller.dart';

class StoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoryController>(() => StoryController());
  }
}
