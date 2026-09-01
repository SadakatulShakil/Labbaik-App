import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/localization/locale_keys.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../domain/entities/chapter_content.dart';
import '../../../domain/entities/dua_content.dart';
import '../../../domain/repositories/progress_repository.dart';

/// The kind of content a [ReadingBlock] carries — drives both how it's
/// rendered and how it's narrated.
enum ReadingKind { sectionHeader, plainBody, step, tip, duaHeader, dua }

/// One narratable, scrollable-to unit of a chapter's content. The same list
/// of blocks drives both the visual layout and the narration order, so the
/// two never drift out of sync.
class ReadingBlock {
  ReadingBlock({
    required this.kind,
    this.text,
    this.stepNumber,
    this.dua,
    required this.narration,
  });

  final GlobalKey key = GlobalKey();
  final ReadingKind kind;
  final String? text;
  final int? stepNumber;
  final DuaContent? dua;
  final String narration;
}

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

  List<ReadingBlock>? _blocks;

  List<ReadingBlock> get blocks => _blocks ??= _buildBlocks();

  @override
  void onInit() {
    super.onInit();
    _loadCompletion();
  }

  Future<void> _loadCompletion() async {
    final completed = await _progress.completedChapterIds(_journey);
    isCompleted.value = completed.contains(chapter.id);
  }

  List<ReadingBlock> _buildBlocks() {
    final result = <ReadingBlock>[];
    final sections = [...chapter.sections]
      ..sort((a, b) => a.order.compareTo(b.order));

    for (final section in sections) {
      final headerKey = switch (section.type) {
        'steps' => Keys.sectionSteps,
        'tip' => Keys.sectionTips,
        _ => Keys.sectionInShort,
      };
      final headerText = headerKey.tr;
      result.add(ReadingBlock(
        kind: ReadingKind.sectionHeader,
        text: headerText,
        narration: headerText,
      ));

      final body = isBn ? section.bodyBn : section.bodyEn;

      if (section.type == 'tip') {
        result.add(ReadingBlock(
          kind: ReadingKind.tip,
          text: body,
          narration: body,
        ));
      } else if (section.type == 'steps' && body.contains('\n')) {
        final steps = body
            .split('\n')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
        for (var i = 0; i < steps.length; i++) {
          final n = i + 1;
          result.add(ReadingBlock(
            kind: ReadingKind.step,
            text: steps[i],
            stepNumber: n,
            narration: '${Keys.stepWord.tr} $n. ${steps[i]}',
          ));
        }
      } else {
        result.add(ReadingBlock(
          kind: ReadingKind.plainBody,
          text: body,
          narration: body,
        ));
      }
    }

    if (chapter.duas.isNotEmpty) {
      final duaHeaderText = Keys.sectionDuas.tr;
      result.add(ReadingBlock(
        kind: ReadingKind.duaHeader,
        text: duaHeaderText,
        narration: duaHeaderText,
      ));
      for (final dua in chapter.duas) {
        final meaning = isBn ? dua.meaningBn : dua.meaningEn;
        result.add(ReadingBlock(
          kind: ReadingKind.dua,
          dua: dua,
          narration: meaning,
        ));
      }
    }

    return result;
  }

  Future<void> narrateChapter() async {
    final items = blocks;
    isNarrating.value = true;
    try {
      await _tts.prepare();
      for (final b in items) {
        if (!isNarrating.value) break;
        final ctx = b.key.currentContext;
        if (ctx != null && ctx.mounted) {
          await Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 300),
            alignment: 0.15,
            curve: Curves.easeInOut,
          );
        }
        if (!isNarrating.value) break;
        await _tts.speakSegment(b.narration);
      }
      if (isNarrating.value) {
        final next = (isCompleted.value && chapter.story != null)
            ? Keys.nowViewStory.tr
            : (!isCompleted.value ? Keys.nowMarkComplete.tr : null);
        if (next != null) await _tts.speakSegment(next);
      }
    } finally {
      isNarrating.value = false;
    }
  }

  Future<void> stopNarration() async {
    await _tts.stop();
    isNarrating.value = false;
  }

  Future<void> complete() async {
    await stopNarration();
    await _progress.markCompleted(_journey, chapter.id);
    if (chapter.story != null) {
      // Replaces the chapter route so there's no flash of it on return.
      Get.offNamed(Routes.story, arguments: {'chapter': chapter, 'review': false});
    } else {
      Get.back(result: true);
    }
  }

  Future<void> openStoryReview() async {
    await stopNarration();
    Get.toNamed(Routes.story, arguments: {'chapter': chapter, 'review': true});
  }

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }
}
