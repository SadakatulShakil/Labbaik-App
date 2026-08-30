import 'package:get/get.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../domain/entities/chapter_content.dart';
import '../../../domain/repositories/progress_repository.dart';

class ChapterController extends GetxController {
  final ChapterContent chapter = Get.arguments as ChapterContent;

  final ProgressRepository _progress = Get.find<ProgressRepository>();
  final StorageService _storage = Get.find<StorageService>();
  final TtsService _tts = Get.find<TtsService>();

  final isCompleted = false.obs;
  final isNarrating = false.obs;

  bool get isBn => (Get.locale?.languageCode ?? 'bn') == 'bn';

  bool get ttsEnabled => _storage.ttsEnabled;

  double get textScale => _storage.textScale;

  String get _journey => _storage.selectedJourney ?? 'umrah';

  @override
  void onInit() {
    super.onInit();
    _loadCompletion();
  }

  Future<void> _loadCompletion() async {
    final completed = await _progress.completedChapterIds(_journey);
    isCompleted.value = completed.contains(chapter.id);
  }

  Future<void> narrateChapter() async {
    final sections = [...chapter.sections]
      ..sort((a, b) => a.order.compareTo(b.order));
    final text =
        sections.map((s) => isBn ? s.bodyBn : s.bodyEn).join('. ');
    if (text.trim().isEmpty) return;

    isNarrating.value = true;
    try {
      await _tts.speak(text);
    } finally {
      isNarrating.value = false;
    }
  }

  Future<void> stopNarration() async {
    await _tts.stop();
    isNarrating.value = false;
  }

  Future<void> complete() async {
    await _progress.markCompleted(_journey, chapter.id);
    Get.back(result: true);
  }

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }
}
