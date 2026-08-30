/// Central registry of bundled asset paths. Populate as content is added
/// (Phase 3+). Keeping paths here avoids magic strings scattered across views.
class AppAssets {
  AppAssets._();

  static const fontsBasePath = 'assets/fonts';
  static const imagesBasePath = 'assets/images';
  static const dataBasePath = 'assets/data';

  // TODO: Arabic font in content phase.
}
