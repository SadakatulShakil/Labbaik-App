import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

import 'storage_service.dart';

/// Wraps [FlutterTts] to narrate chapter content in the current locale.
/// Registered once as a permanent [GetxService].
class TtsService extends GetxService {
  final FlutterTts _tts = FlutterTts();
  final StorageService _storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    // Lets `speak()` complete only once playback finishes, so callers can
    // treat it as a simple await-and-done narration call.
    _tts.awaitSpeakCompletion(true);
  }

  Future<void> speak(String text) async {
    if (!_storage.ttsEnabled) return;

    final langCode = Get.locale?.languageCode ?? 'bn';
    final sanitized = sanitizeForTts(text, langCode);
    if (sanitized.isEmpty) return;

    await stop();
    await _tts.setLanguage(langCode == 'bn' ? 'bn-BD' : 'en-US');
    await _tts.setSpeechRate(_storage.ttsSpeed);
    await _tts.speak(sanitized);
  }

  Future<void> stop() => _tts.stop();

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }
}

/// Strips markdown/bracket placeholders and normalizes whitespace/punctuation
/// so bn-BD/en-US TTS engines read chapter text cleanly.
String sanitizeForTts(String text, String langCode) {
  var out = text;
  out = out.replaceAll(RegExp(r'\[[^\]]*\]'), ' ');
  out = out.replaceAll(RegExp(r'[*_`#>]+'), '');
  out = out.replaceAll(RegExp(r'\s+'), ' ').trim();

  if (langCode == 'bn') {
    out = out.replaceAll('॥', '।');
    out = out.replaceAll(RegExp(r'।+'), '।');
    out = out.replaceAll(RegExp(r'\.{2,}'), '.');
  }

  return out;
}
