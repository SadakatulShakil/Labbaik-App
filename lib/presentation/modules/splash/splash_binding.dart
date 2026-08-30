import 'package:get/get.dart';

import 'splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Must be eager: nothing in SplashView calls Get.find, so a lazyPut
    // controller would never be constructed and onReady() would never fire.
    Get.put<SplashController>(SplashController());
  }
}
