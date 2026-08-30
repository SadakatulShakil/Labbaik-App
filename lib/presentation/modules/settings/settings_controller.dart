import 'package:get/get.dart';

import '../../../core/constants/app_strings_keys.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../domain/repositories/progress_repository.dart';

class SettingsController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final ProgressRepository _progress = Get.find<ProgressRepository>();
  final TtsService _tts = Get.find<TtsService>();

  late final textScale = _storage.textScale.obs;
  late final ttsEnabled = _storage.ttsEnabled.obs;
  late final ttsSpeed = _storage.ttsSpeed.obs;

  bool get _isBn => (Get.locale?.languageCode ?? 'bn') == 'bn';

  String get currentLanguageLabel => _isBn ? Keys.bangla.tr : Keys.english.tr;

  String get currentJourneyLabel =>
      (_storage.selectedJourney ?? 'umrah') == 'hajj'
          ? Keys.hajj.tr
          : Keys.umrah.tr;

  void openLanguage() => Get.toNamed(Routes.language, arguments: true);

  void setTextScale(double value) {
    textScale.value = value;
    _storage.setTextScale(value);
  }

  void toggleTts(bool value) {
    ttsEnabled.value = value;
    _storage.setTtsEnabled(value);
  }

  void setTtsSpeed(double value) {
    ttsSpeed.value = value;
    _storage.setTtsSpeed(value);
  }

  Future<void> testTts() {
    return _tts.speak(
      _isBn ? 'এভাবে শোনা যাবে।' : 'This is how narration sounds.',
    );
  }

  Future<void> resetCurrentJourney() {
    return _progress.resetJourney(_storage.selectedJourney ?? 'umrah');
  }
}
