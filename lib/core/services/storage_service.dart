import 'package:get_storage/get_storage.dart';

/// Thin typed wrapper around [GetStorage]. Call `GetStorage.init()` in
/// `main()` before this service is constructed.
class StorageService {
  StorageService() : _box = GetStorage();

  final GetStorage _box;

  static const _keyFirstLaunch = 'firstLaunch';
  static const _keyLanguageCode = 'languageCode';
  static const _keyTextScale = 'textScale';
  static const _keyTtsEnabled = 'ttsEnabled';
  static const _keyTtsSpeed = 'ttsSpeed';
  static const _keySelectedJourney = 'selectedJourney';

  bool get isFirstLaunch => _box.read<bool>(_keyFirstLaunch) ?? true;

  Future<void> setFirstLaunchDone() => _box.write(_keyFirstLaunch, false);

  String? get languageCode => _box.read<String>(_keyLanguageCode);

  Future<void> setLanguageCode(String code) =>
      _box.write(_keyLanguageCode, code);

  double get textScale => _box.read<double>(_keyTextScale) ?? 1.0;

  Future<void> setTextScale(double value) =>
      _box.write(_keyTextScale, value);

  bool get ttsEnabled => _box.read<bool>(_keyTtsEnabled) ?? true;

  Future<void> setTtsEnabled(bool value) =>
      _box.write(_keyTtsEnabled, value);

  double get ttsSpeed => _box.read<double>(_keyTtsSpeed) ?? 0.5;

  Future<void> setTtsSpeed(double value) => _box.write(_keyTtsSpeed, value);

  /// `'umrah'` or `'hajj'`.
  String? get selectedJourney => _box.read<String>(_keySelectedJourney);

  Future<void> setSelectedJourney(String journey) =>
      _box.write(_keySelectedJourney, journey);
}
