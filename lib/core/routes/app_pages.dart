import 'package:get/get.dart';

import '../../presentation/modules/home/home_binding.dart';
import '../../presentation/modules/home/home_view.dart';
import '../../presentation/modules/journey_select/journey_select_binding.dart';
import '../../presentation/modules/journey_select/journey_select_view.dart';
import '../../presentation/modules/language/language_binding.dart';
import '../../presentation/modules/language/language_view.dart';
import '../../presentation/modules/onboarding/onboarding_binding.dart';
import '../../presentation/modules/onboarding/onboarding_view.dart';
import '../../presentation/modules/splash/splash_binding.dart';
import '../../presentation/modules/splash/splash_view.dart';
import 'app_routes.dart';

/// Registered GetPage routes with their bindings. Add one entry per screen
/// as phases land.
abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.language,
      page: () => const LanguageView(),
      binding: LanguageBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.journeySelect,
      page: () => const JourneySelectView(),
      binding: JourneySelectBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
