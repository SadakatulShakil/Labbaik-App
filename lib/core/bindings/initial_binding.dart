import 'package:get/get.dart';

import '../../data/datasources/local/app_database.dart';
import '../../data/repositories/checklist_repository_impl.dart';
import '../../data/repositories/content_repository_impl.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../domain/repositories/checklist_repository.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../services/storage_service.dart';

/// Registers app-wide singletons available for the lifetime of the app.
/// Add further shared services here as phases land.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StorageService>(StorageService(), permanent: true);

    final db = Get.find<AppDatabase>();
    Get.put<ContentRepository>(ContentRepositoryImpl(), permanent: true);
    Get.put<ProgressRepository>(
      ProgressRepositoryImpl(db.progressDao),
      permanent: true,
    );
    Get.put<ChecklistRepository>(
      ChecklistRepositoryImpl(db.checklistDao),
      permanent: true,
    );
  }
}
