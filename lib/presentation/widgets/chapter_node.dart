import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings_keys.dart';
import '../../core/utils/icon_from_name.dart';
import '../../domain/entities/chapter_content.dart';
import '../modules/home/chapter_state.dart';

/// One node on the Home chapter trail: a large ring-style circle with the
/// chapter icon, colored by [state], plus a centered title below it.
/// Connectors between nodes are drawn by the trail painter, not here.
class ChapterNode extends StatefulWidget {
  const ChapterNode({
    super.key,
    required this.chapter,
    required this.state,
    required this.isCurrent,
    required this.onTap,
  });

  final ChapterContent chapter;
  final ChapterState state;
  final bool isCurrent;
  final VoidCallback onTap;

  /// Ring diameter in design pixels (scale with `.w` at call sites).
  static const double nodeSize = 120.0;

  @override
  State<ChapterNode> createState() => _ChapterNodeState();
}

class _ChapterNodeState extends State<ChapterNode>
    with SingleTickerProviderStateMixin {
  AnimationController? _pulseController;

  bool get _shouldPulse =>
      widget.isCurrent && widget.state == ChapterState.unlocked;

  @override
  void initState() {
    super.initState();
    if (_shouldPulse) _startPulse();
  }

  @override
  void didUpdateWidget(covariant ChapterNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldPulse && _pulseController == null) {
      _startPulse();
    } else if (!_shouldPulse && _pulseController != null) {
      _pulseController!.dispose();
      _pulseController = null;
    }
  }

  void _startPulse() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  Color get _ringColor {
    switch (widget.state) {
      case ChapterState.locked:
        return AppColors.locked;
      case ChapterState.unlocked:
        return AppColors.primary;
      case ChapterState.completed:
        return AppColors.accentGold;
    }
  }

  Color get _iconColor {
    switch (widget.state) {
      case ChapterState.locked:
        return AppColors.locked;
      case ChapterState.unlocked:
        return AppColors.primary;
      case ChapterState.completed:
        return AppColors.accentGold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = (Get.locale?.languageCode ?? 'bn') == 'bn';
    final title = isBn ? widget.chapter.titleBn : widget.chapter.titleEn;
    final isLocked = widget.state == ChapterState.locked;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRing(),
          SizedBox(height: 10.h),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isLocked
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
          ),
          if (widget.state == ChapterState.completed) ...[
            SizedBox(height: 6.h),
            _buildPill(Keys.completedExclaim.tr, AppColors.accentGold),
          ] else if (_shouldPulse) ...[
            SizedBox(height: 6.h),
            _buildPill(Keys.startHere.tr, AppColors.primary),
          ],
        ],
      ),
    );
  }

  Widget _buildRing() {
    final size = ChapterNode.nodeSize.w;
    final isLocked = widget.state == ChapterState.locked;

    Widget ring = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.all(color: _ringColor, width: 6.w),
      ),
      child: Center(
        // TODO: swap Material icon for a per-chapter illustration asset later.
        child: Image.asset(
          'assets/images/chapters/${widget.chapter.id}.png',
          width: 56.w, height: 56.w,
          errorBuilder: (_, __, ___) => Icon(iconFromName(widget.chapter.icon)), // fallback
        )
      ),
    );

    if (isLocked) {
      ring = Opacity(opacity: 0.55, child: ring);
    }

    if (_pulseController != null) {
      ring = AnimatedBuilder(
        animation: _pulseController!,
        builder: (context, child) {
          final t = _pulseController!.value;
          return DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentGold.withValues(
                    alpha: 0.22 + 0.22 * t,
                  ),
                  blurRadius: 14 + 12 * t,
                  spreadRadius: 1 + 4 * t,
                ),
              ],
            ),
            child: child,
          );
        },
        child: ring,
      );
    }

    return SizedBox(
      width: size + 16.w,
      height: size + 16.w,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          ring,
          if (widget.state == ChapterState.completed)
            Positioned(
              top: 0,
              right: 0,
              child: _buildBadge(Icons.check, AppColors.success),
            ),
          if (isLocked)
            Positioned(
              top: 0,
              right: 0,
              child: _buildBadge(Icons.lock, AppColors.textSecondary),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.all(color: color, width: 2.w),
      ),
      child: Icon(icon, size: 16.sp, color: color),
    );
  }

  Widget _buildPill(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.surface,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
