import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings_keys.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../domain/entities/chapter_content.dart';
import '../../../domain/entities/story_content.dart';
import '../../../domain/repositories/content_repository.dart';

class StoryController extends GetxController {
  final Map _args = Get.arguments as Map;
  late final ChapterContent chapter = _args['chapter'] as ChapterContent;
  late final bool isReview = _args['review'] == true;

  final StorageService _storage = Get.find<StorageService>();
  final ContentRepository _content = Get.find<ContentRepository>();
  final TtsService _tts = Get.find<TtsService>();

  StoryContent? get story => chapter.story;

  final isNarrating = false.obs;
  final isLastChapter = false.obs;

  final GlobalKey titleKey = GlobalKey();
  final GlobalKey bodyKey = GlobalKey();

  bool get isBn => (Get.locale?.languageCode ?? 'bn') == 'bn';

  bool get ttsEnabled => _storage.ttsEnabled;

  double get textScale => _storage.textScale;

  String get journeyTitleKey => _journey == 'hajj' ? Keys.hajj : Keys.umrah;

  String get _journey => _storage.selectedJourney ?? 'umrah';

  @override
  void onInit() {
    super.onInit();
    _checkLastChapter();
  }

  Future<void> _checkLastChapter() async {
    final chapters = await _content.getChapters(_journey);
    isLastChapter.value = chapter.order == chapters.length;
  }

  Future<void> narrateStory() async {
    final s = story;
    if (s == null) return;

    final segments = <(GlobalKey, String)>[
      (titleKey, isBn ? s.titleBn : s.titleEn),
      (bodyKey, isBn ? s.bodyBn : s.bodyEn),
    ];

    isNarrating.value = true;
    try {
      await _tts.prepare();
      for (final (key, text) in segments) {
        if (!isNarrating.value) break;
        if (text.trim().isEmpty) continue;
        final ctx = key.currentContext;
        if (ctx != null && ctx.mounted) {
          await Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 300),
            alignment: 0.15,
            curve: Curves.easeInOut,
          );
        }
        if (!isNarrating.value) break;
        await _tts.speakSegment(text);
      }
    } finally {
      isNarrating.value = false;
    }
  }

  Future<void> stopNarration() async {
    await _tts.stop();
    isNarrating.value = false;
  }

  Future<void> goHome() async {
    await _tts.stop();
    Get.until((route) => route.settings.name == Routes.home);
  }

  Future<void> dismiss() async {
    await _tts.stop();
    if (isReview) {
      Get.back();
    } else {
      Get.until((route) => route.settings.name == Routes.home);
    }
  }

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }
}
