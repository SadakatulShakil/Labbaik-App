import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/bindings/initial_binding.dart';
import 'core/localization/app_translations.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final db = await $FloorAppDatabase.databaseBuilder('labbaik.db').build();
  Get.put<AppDatabase>(db, permanent: true);

  runApp(const LabbaikApp());
}

class LabbaikApp extends StatelessWidget {
  const LabbaikApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCode = StorageService().languageCode;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => GetMaterialApp(
        title: 'Labbaik',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        translations: AppTranslations(),
        locale: languageCode != null ? Locale(languageCode) : null,
        fallbackLocale: const Locale('bn'),
        initialBinding: InitialBinding(),
        initialRoute: Routes.splash,
        getPages: AppPages.pages,
      ),
    );
  }
}
