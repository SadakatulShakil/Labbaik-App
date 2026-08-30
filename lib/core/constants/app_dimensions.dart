import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared spacing, radius, and sizing constants (in logical px, scaled via .sp/.r/.w/.h at call sites).
class AppDimensions {
  AppDimensions._();

  static double get paddingXs => 4.w;
  static double get paddingSm => 8.w;
  static double get paddingMd => 16.w;
  static double get paddingLg => 24.w;
  static double get paddingXl => 32.w;

  static double get radiusMd => 12.r;
  static double get radiusLg => 16.r;

  /// Minimum tap target height for elderly users (accessibility guideline).
  static double get buttonHeight => 52.h;

  static double get bodyFontSize => 16.sp;
  static double get titleFontSize => 22.sp;
  static double get headlineFontSize => 28.sp;
}
