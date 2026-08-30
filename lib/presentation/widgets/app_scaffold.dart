import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import 'pilgrim_background.dart';

/// Shared full-screen scaffold used by every page: the bundled pilgrimage
/// image behind the content, a transparent status bar with dark icons, and
/// an optional header (back button / title / actions) floating on the image.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    this.showBack = false,
    this.actions,
    this.scrimAlpha = 0.15,
    required this.body,
  });

  /// Header title widget (e.g. `Text` or `Obx`). Null means no title.
  final Widget? title;

  /// Shows a back button in the header that calls `Get.back()`.
  final bool showBack;

  /// Header trailing widgets (e.g. a settings icon).
  final List<Widget>? actions;

  /// Cream veil strength over the background image; raise on text-heavy pages.
  final double scrimAlpha;

  final Widget body;

  static const _statusBarStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  bool get _hasHeader => title != null || showBack || actions != null;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusBarStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            PilgrimBackground(scrimAlpha: scrimAlpha),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  if (_hasHeader) _buildHeader(),
                  Expanded(child: body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        showBack ? AppDimensions.paddingXs : AppDimensions.paddingLg,
        AppDimensions.paddingMd,
        AppDimensions.paddingSm,
        AppDimensions.paddingSm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background.withValues(alpha: 0.5),
            AppColors.background.withValues(alpha: 0),
          ],
        ),
      ),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              onPressed: Get.back,
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            ),
          Expanded(
            child: title == null
                ? const SizedBox.shrink()
                : DefaultTextStyle.merge(
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    child: title!,
                  ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
