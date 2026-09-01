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
    final topPadding = 20.h;
    // Clears the system navigation bar (drawn under, in edge-to-edge mode)
    // plus a little breathing room below the last node.
    final navBarInset = MediaQuery.of(context).padding.bottom;
    final bottomPadding = 140.h + navBarInset + 24.h;
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
      final state = stateOf(chapter);

      children.add(
        Positioned(
          left: center.dx - half,
          top: center.dy - ringSize / 2,
          width: nodeWidth,
          child: _PopIn(
            key: ValueKey('pop_${chapter.id}'),
            index: i,
            child: ChapterNode(
              key: ValueKey(chapter.id),
              chapter: chapter,
              state: state,
              isCurrent: isCurrent(chapter),
              onTap: () => onChapterTap(chapter, state),
            ),
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

/// Scales + fades its child in once, staggered by [index] — the gentle
/// "bubble" entrance for a chapter node as the path first appears.
class _PopIn extends StatefulWidget {
  const _PopIn({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<_PopIn> createState() => _PopInState();
}

class _PopInState extends State<_PopIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  late final Animation<double> _scale =
      CurvedAnimation(parent: _c, curve: Curves.elasticOut);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 50 + widget.index * 100), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _c,
        child: ScaleTransition(scale: _scale, child: widget.child),
      );
}
