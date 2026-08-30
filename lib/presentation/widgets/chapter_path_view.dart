import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings_keys.dart';
import '../../domain/entities/chapter_content.dart';
import '../modules/home/chapter_state.dart';
import 'chapter_node.dart';

/// Lays chapters out on a winding vertical trail: nodes alternate left/right
/// to form smooth S-curves, connected by a dashed/solid bezier trail that
/// fills in solid gold as chapters are completed.
class ChapterPathView extends StatelessWidget {
  const ChapterPathView({
    super.key,
    required this.chapters,
    required this.stateOf,
    required this.isCurrent,
    required this.onChapterTap,
  });

  final List<ChapterContent> chapters;
  final ChapterState Function(ChapterContent chapter) stateOf;
  final bool Function(ChapterContent chapter) isCurrent;
  final void Function(ChapterContent chapter, ChapterState state)
      onChapterTap;

  static const double _nodeWidth = 170.0;

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) return const SizedBox.shrink();

    final ringSize = ChapterNode.nodeSize.w;
    final nodeWidth = _nodeWidth.w;
    final step = ChapterNode.nodeSize.w + 96.h;
    final topPadding = 72.h;
    final bottomPadding = 140.h;
    final totalHeight =
        topPadding + step * (chapters.length - 1) + ringSize + bottomPadding;

    final width = MediaQuery.of(context).size.width;
    final half = nodeWidth / 2;
    double clampX(double x) =>
        x.clamp(half + 8.w, width - half - 8.w).toDouble();
    final leftX = clampX(width * 0.22);
    final rightX = clampX(width * 0.78);

    final centers = <Offset>[
      for (var i = 0; i < chapters.length; i++)
        Offset(
          i.isEven ? leftX : rightX,
          topPadding + ringSize / 2 + step * i,
        ),
    ];

    // Index of the furthest node that is completed or the current chapter —
    // the trail is drawn solid gold up to this node, dashed grey beyond it.
    var solidUpTo = -1;
    for (var i = 0; i < chapters.length; i++) {
      if (stateOf(chapters[i]) == ChapterState.completed ||
          isCurrent(chapters[i])) {
        solidUpTo = i;
      }
    }

    final children = <Widget>[
      Positioned.fill(
        child: CustomPaint(
          painter: _TrailPainter(centers: centers, solidUpTo: solidUpTo),
        ),
      ),
    ];

    for (var i = 0; i < chapters.length; i++) {
      final chapter = chapters[i];
      final center = centers[i];

      if (i == 0 || chapter.phase != chapters[i - 1].phase) {
        final labelY =
            i == 0 ? topPadding * 0.5 : (centers[i - 1].dy + center.dy) / 2;
        children.add(
          Positioned(
            top: labelY - 12.h,
            left: 0,
            right: 0,
            child: Center(child: _PhaseLabelChip(phase: chapter.phase)),
          ),
        );
      }

      final state = stateOf(chapter);
      children.add(
        Positioned(
          left: center.dx - half,
          top: center.dy - ringSize / 2,
          width: nodeWidth,
          child: ChapterNode(
            chapter: chapter,
            state: state,
            isCurrent: isCurrent(chapter),
            onTap: () => onChapterTap(chapter, state),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: totalHeight,
        width: double.infinity,
        child: Stack(children: children),
      ),
    );
  }
}

class _PhaseLabelChip extends StatelessWidget {
  const _PhaseLabelChip({required this.phase});

  final String phase;

  @override
  Widget build(BuildContext context) {
    final key = switch (phase) {
      'preparation' => Keys.phasePreparation,
      'rites' => Keys.phaseRites,
      'after' => Keys.phaseAfter,
      _ => Keys.phasePreparation,
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(
        key.tr,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

/// Draws a smooth dashed/solid bezier trail through consecutive node
/// centers. Segments up to and including the current node are solid gold;
/// remaining segments are dashed grey.
class _TrailPainter extends CustomPainter {
  _TrailPainter({required this.centers, required this.solidUpTo});

  final List<Offset> centers;
  final int solidUpTo;

  @override
  void paint(Canvas canvas, Size size) {
    if (centers.length < 2) return;

    final solidPaint = Paint()
      ..color = AppColors.accentGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final dashedPaint = Paint()
      ..color = AppColors.locked
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < centers.length - 1; i++) {
      final start = centers[i];
      final end = centers[i + 1];
      final controlOffsetY = (end.dy - start.dy) * 0.5;
      final p1 = Offset(start.dx, start.dy + controlOffsetY);
      final p2 = Offset(end.dx, end.dy - controlOffsetY);

      final segmentPath = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, end.dx, end.dy);

      final isSolid = i + 1 <= solidUpTo;
      if (isSolid) {
        canvas.drawPath(segmentPath, solidPaint);
      } else {
        _drawDashed(canvas, segmentPath, dashedPaint);
      }
    }
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 10.0;
    const dashGap = 8.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TrailPainter oldDelegate) {
    return oldDelegate.centers != centers ||
        oldDelegate.solidUpTo != solidUpTo;
  }
}
