import 'package:get/get.dart';

import '../../../core/constants/app_strings_keys.dart';
import '../../../core/services/storage_service.dart';
import '../../../domain/entities/chapter_content.dart';
import '../../../domain/repositories/content_repository.dart';
import '../../../domain/repositories/progress_repository.dart';
import 'chapter_state.dart';

class HomeController extends GetxController {
  final ContentRepository _content = Get.find<ContentRepository>();
  final ProgressRepository _progress = Get.find<ProgressRepository>();
  final StorageService _storage = Get.find<StorageService>();

  final journey = ''.obs;
  final chapters = <ChapterContent>[].obs;
  final completed = <String>{}.obs;
  final loading = true.obs;

  final isSwitching = false.obs;
  final switchFrom = 'umrah'.obs;
  final switchTo = 'hajj'.obs;

  @override
  void onInit() {
    super.onInit();
    journey.value = _storage.selectedJourney ?? 'umrah';
    load();
  }

  Future<void> load() async {
    loading.value = true;
    final loaded = await _content.getChapters(journey.value);
    loaded.sort((a, b) => a.order.compareTo(b.order));
    chapters.value = loaded;
    completed.assignAll(await _progress.completedChapterIds(journey.value));
    loading.value = false;
  }

  Future<void> switchJourney(String j) async {
    if (j == journey.value || isSwitching.value) return;
    switchFrom.value = journey.value;
    switchTo.value = j;
    isSwitching.value = true;
    await Future.delayed(const Duration(milliseconds: 1100)); // let it establish + the marker travel
    _storage.setSelectedJourney(j);
    journey.value = j;
    await load();                                            // new chapters/progress load under the overlay
    await Future.delayed(const Duration(milliseconds: 1000)); // hold a beat, then reveal
    isSwitching.value = false;
  }

  ChapterState stateOf(ChapterContent c) {
    if (completed.contains(c.id)) return ChapterState.completed;

    if (c.order == 1) return ChapterState.unlocked;

    ChapterContent? previous;
    for (final candidate in chapters) {
      if (candidate.order == c.order - 1) {
        previous = candidate;
        break;
      }
    }
    if (previous != null && completed.contains(previous.id)) {
      return ChapterState.unlocked;
    }
    return ChapterState.locked;
  }

  bool isCurrent(ChapterContent c) {
    for (final chapter in chapters) {
      if (stateOf(chapter) == ChapterState.unlocked) {
        return chapter.id == c.id;
      }
    }
    return false;
  }

  int get completedCount => completed.length;

  int get total => chapters.length;

  String get journeyTitleKey =>
      journey.value == 'hajj' ? Keys.hajj : Keys.umrah;
}
