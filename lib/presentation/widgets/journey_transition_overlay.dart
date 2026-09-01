// import 'dart:math' as math;
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../core/constants/app_colors.dart';
// import '../../core/constants/app_strings_keys.dart';
//
// class JourneyTransitionOverlay extends StatefulWidget {
//   const JourneyTransitionOverlay({
//     super.key,
//     required this.fromJourney,
//     required this.toJourney,
//   });
//
//   /// 'umrah' or 'hajj'.
//   final String fromJourney;
//   final String toJourney;
//
//   @override
//   State<JourneyTransitionOverlay> createState() =>
//       _JourneyTransitionOverlayState();
// }
//
// class _JourneyTransitionOverlayState extends State<JourneyTransitionOverlay>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//
//   // Fixed star field — generated once, not on every rebuild.
//   static final List<Offset> _stars = List.generate(
//     26,
//         (i) => Offset(
//       math.Random(i * 91).nextDouble(),
//       math.Random(i * 53 + 7).nextDouble(),
//     ),
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     )..forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   String _titleKey(String journey) =>
//       journey == 'hajj' ? Keys.hajj : Keys.umrah;
//
//   // Umrah's defining rite is tawaf around the Kaaba; Hajj adds standing at
//   // Arafat, so the two get visually distinct icons rather than sharing one.
//   IconData _journeyIcon(String journey) =>
//       journey == 'hajj' ? Icons.terrain_rounded : Icons.mosque_rounded;
//
//   @override
//   Widget build(BuildContext context) {
//     final fromTitle = _titleKey(widget.fromJourney).tr;
//     final toTitle = _titleKey(widget.toJourney).tr;
//
//     // Choreography: overlapping intervals so nothing feels mechanical.
//     final glow = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
//     );
//     final arcProgress = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.05, 0.85, curve: Curves.easeInOut),
//     );
//     final fromFade = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
//     );
//     final toRise = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.25, 1.0, curve: Curves.easeOut),
//     );
//     final captionFade = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
//     );
//
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [AppColors.primary, AppColors.primaryDark],
//         ),
//       ),
//       child: Stack(
//         children: [
//           Positioned.fill(
//             child: CustomPaint(painter: _StarFieldPainter(_stars)),
//           ),
//           Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 AnimatedBuilder(
//                   animation: glow,
//                   builder: (context, child) => Opacity(
//                     opacity: glow.value,
//                     child: Transform.scale(
//                       scale: 0.85 + (0.15 * glow.value),
//                       child: child,
//                     ),
//                   ),
//                   child: _TalbiyahGlow(),
//                 ),
//                 SizedBox(height: 18.h),
//                 SizedBox(
//                   height: 132.h,
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       final path = _arcPath(constraints.biggest);
//                       return AnimatedBuilder(
//                         animation: Listenable.merge(
//                             [arcProgress, fromFade, toRise]),
//                         builder: (context, _) {
//                           final metric = path.computeMetrics().first;
//                           final tangent = metric.getTangentForOffset(
//                             metric.length * arcProgress.value,
//                           );
//                           final markerPos = tangent?.position ??
//                               Offset(0, constraints.maxHeight);
//
//                           return Stack(
//                             children: [
//                               CustomPaint(
//                                 size: constraints.biggest,
//                                 painter: _ArcPathPainter(
//                                   path: path,
//                                   metric: metric,
//                                   progress: arcProgress.value,
//                                 ),
//                               ),
//                               Positioned(
//                                 left: 4.w,
//                                 bottom: 4.h,
//                                 child: Opacity(
//                                   opacity: 1 - (fromFade.value * 0.65),
//                                   child: Transform.scale(
//                                     scale: 1 - (fromFade.value * 0.1),
//                                     alignment: Alignment.bottomLeft,
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Text(
//                                           fromTitle,
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 18.sp,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                         SizedBox(width: 6.w),
//                                         Icon(
//                                           _journeyIcon(widget.fromJourney),
//                                           color: Colors.white,
//                                           size: 17.sp,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 right: 4.w,
//                                 top: 4.h,
//                                 child: Opacity(
//                                   opacity: 0.35 + (toRise.value * 0.65),
//                                   child: Transform.scale(
//                                     scale: 0.92 + (toRise.value * 0.13),
//                                     alignment: Alignment.topRight,
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Text(
//                                           toTitle,
//                                           style: TextStyle(
//                                             color: AppColors.accentGold,
//                                             fontSize: 23.sp,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         SizedBox(width: 6.w),
//                                         Icon(
//                                           _journeyIcon(widget.toJourney),
//                                           color: AppColors.accentGold,
//                                           size: 20.sp,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 left: markerPos.dx - 17.r,
//                                 top: markerPos.dy - 17.r,
//                                 child: _TrailMarker(
//                                   fromIcon: _journeyIcon(widget.fromJourney),
//                                   toIcon: _journeyIcon(widget.toJourney),
//                                   progress: arcProgress.value,
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 22.h),
//                 FadeTransition(
//                   opacity: captionFade,
//                   child: Text(
//                     Keys.journeyTravelCaption.trParams({'journey': toTitle}),
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.white, fontSize: 15.sp),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// A gentle rising arc from bottom-left ("from") to top-right ("to").
//   Path _arcPath(Size size) {
//     final start = Offset(28.w, size.height - 26.h);
//     final end = Offset(size.width - 28.w, 22.h);
//     final control = Offset(size.width * 0.5, -10.h);
//     return Path()
//       ..moveTo(start.dx, start.dy)
//       ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
//   }
// }
//
// class _TalbiyahGlow extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: RadialGradient(
//           colors: [
//             AppColors.accentGold.withOpacity(0.22),
//             AppColors.accentGold.withOpacity(0.0),
//           ],
//         ),
//       ),
//       child: Text(
//         'লাব্বাইক',
//         style: TextStyle(
//           fontSize: 40.sp,
//           fontWeight: FontWeight.w700,
//           color: AppColors.accentGold,
//         ),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
// }
//
// class _TrailMarker extends StatelessWidget {
//   const _TrailMarker({
//     required this.fromIcon,
//     required this.toIcon,
//     required this.progress,
//   });
//
//   final IconData fromIcon;
//   final IconData toIcon;
//   final double progress;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 34.r,
//       height: 34.r,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: AppColors.accentGold,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.accentGold.withOpacity(0.5),
//             blurRadius: 12,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       // The badge itself morphs from the departure icon to the arrival
//       // icon as it crosses — it "becomes" what you're arriving at.
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Opacity(
//             opacity: (1 - progress).clamp(0.0, 1.0),
//             child: Icon(fromIcon, color: AppColors.primaryDark, size: 18.sp),
//           ),
//           Opacity(
//             opacity: progress.clamp(0.0, 1.0),
//             child: Icon(toIcon, color: AppColors.primaryDark, size: 18.sp),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Base path stays a dim thread; the portion already crossed lights up gold —
// /// the same "traveled trail" language as the home page's chapter path.
// class _ArcPathPainter extends CustomPainter {
//   _ArcPathPainter({
//     required this.path,
//     required this.metric,
//     required this.progress,
//   });
//
//   final Path path;
//   final PathMetric metric;
//   final double progress;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final basePaint = Paint()
//       ..color = Colors.white.withOpacity(0.18)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2
//       ..strokeCap = StrokeCap.round;
//     canvas.drawPath(path, basePaint);
//
//     if (progress > 0) {
//       final traveled = metric.extractPath(0, metric.length * progress);
//       final litPaint = Paint()
//         ..color = AppColors.accentGold
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2.4
//         ..strokeCap = StrokeCap.round;
//       canvas.drawPath(traveled, litPaint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant _ArcPathPainter oldDelegate) =>
//       oldDelegate.progress != progress;
// }
//
// class _StarFieldPainter extends CustomPainter {
//   _StarFieldPainter(this.stars);
//   final List<Offset> stars;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = Colors.white.withOpacity(0.16);
//     for (final s in stars) {
//       final r = (s.dx * 1.4).remainder(1.6) + 0.6;
//       canvas.drawCircle(
//         Offset(s.dx * size.width, s.dy * size.height),
//         r,
//         paint,
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant _StarFieldPainter oldDelegate) => false;
// }

// journey_transition_overlay.dart
//
// Redesign notes:
//   - Replaces the plain horizontal slide with an arc path — the marker
//     rises from "from" to "to", and the path lights up gold behind it as
//     it travels, echoing the trail-lighting-up device used on the home
//     page. Same idea, same vocabulary, two screens.
//   - The traveling marker is now a gold circle badge — deliberately the
//     same shape/size language as the "completed" node on the home trail,
//     so the transition reads as a continuation of that trail, not a
//     separate animation style.
//   - "From" fades and settles as you leave it; "To" brightens and lifts
//     as you arrive — the labels themselves carry the motion, not just
//     the icon.
//   - A few static stars behind the gradient (fixed, not looping) give the
//     night-journey scrim some depth without adding a second animation.
//   - Same public API (fromJourney/toJourney) — drop-in replacement.

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings_keys.dart';

class JourneyTransitionOverlay extends StatefulWidget {
  const JourneyTransitionOverlay({
    super.key,
    required this.fromJourney,
    required this.toJourney,
  });

  /// 'umrah' or 'hajj'.
  final String fromJourney;
  final String toJourney;

  @override
  State<JourneyTransitionOverlay> createState() =>
      _JourneyTransitionOverlayState();
}

class _JourneyTransitionOverlayState extends State<JourneyTransitionOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Fixed star field — generated once, not on every rebuild.
  static final List<Offset> _stars = List.generate(
    26,
        (i) => Offset(
      math.Random(i * 91).nextDouble(),
      math.Random(i * 53 + 7).nextDouble(),
    ),
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _titleKey(String journey) =>
      journey == 'hajj' ? Keys.hajj : Keys.umrah;

  // Umrah's defining rite is tawaf around the Kaaba; Hajj adds standing at
  // Arafat, so the two get visually distinct icons rather than sharing one.
  IconData _journeyIcon(String journey) =>
      journey == 'hajj' ? Icons.terrain_rounded : Icons.mosque_rounded;

  @override
  Widget build(BuildContext context) {
    final fromTitle = _titleKey(widget.fromJourney).tr;
    final toTitle = _titleKey(widget.toJourney).tr;

    // Choreography: overlapping intervals so nothing feels mechanical.
    final glow = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
    );
    final arcProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.05, 0.85, curve: Curves.easeInOut),
    );
    final fromFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
    );
    final toRise = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 1.0, curve: Curves.easeOut),
    );
    final captionFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _StarFieldPainter(_stars)),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: glow,
                  builder: (context, child) => Opacity(
                    opacity: glow.value,
                    child: Transform.scale(
                      scale: 0.85 + (0.15 * glow.value),
                      child: child,
                    ),
                  ),
                  child: _TalbiyahGlow(),
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  height: 132.h,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Measure each label's actual rendered width so the
                      // arc can be inset past it — this is what makes the
                      // fix work for either word, in either direction,
                      // instead of a guessed fixed offset.
                      final fromLabelWidth = 4.w +
                          17.sp +
                          6.w +
                          _labelWidth(
                            fromTitle,
                            TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.w600),
                          );
                      final toLabelWidth = 4.w +
                          _labelWidth(
                            toTitle,
                            TextStyle(
                                fontSize: 23.sp, fontWeight: FontWeight.bold),
                          ) +
                          6.w +
                          20.sp;
                      // Clamp so an unusually long label can't collapse
                      // the arc to nothing.
                      final startInset = math.min(
                        fromLabelWidth + 14.w,
                        constraints.maxWidth * 0.42,
                      );
                      final endInset = math.min(
                        toLabelWidth + 14.w,
                        constraints.maxWidth * 0.42,
                      );
                      final path = _arcPath(
                          constraints.biggest, startInset, endInset);
                      return AnimatedBuilder(
                        animation: Listenable.merge(
                            [arcProgress, fromFade, toRise]),
                        builder: (context, _) {
                          final metric = path.computeMetrics().first;
                          final tangent = metric.getTangentForOffset(
                            metric.length * arcProgress.value,
                          );
                          final markerPos = tangent?.position ??
                              Offset(0, constraints.maxHeight);

                          return Stack(
                            children: [
                              CustomPaint(
                                size: constraints.biggest,
                                painter: _ArcPathPainter(
                                  path: path,
                                  metric: metric,
                                  progress: arcProgress.value,
                                ),
                              ),
                              Positioned(
                                left: 4.w,
                                bottom: 4.h,
                                child: Opacity(
                                  opacity: 1 - (fromFade.value * 0.65),
                                  child: Transform.scale(
                                    scale: 1 - (fromFade.value * 0.1),
                                    alignment: Alignment.bottomLeft,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          fromTitle,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 6.w),
                                        Icon(
                                          _journeyIcon(widget.fromJourney),
                                          color: Colors.white,
                                          size: 17.sp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 4.w,
                                top: 4.h,
                                child: Opacity(
                                  opacity: 0.35 + (toRise.value * 0.65),
                                  child: Transform.scale(
                                    scale: 0.92 + (toRise.value * 0.13),
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          toTitle,
                                          style: TextStyle(
                                            color: AppColors.accentGold,
                                            fontSize: 23.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 6.w),
                                        Icon(
                                          _journeyIcon(widget.toJourney),
                                          color: AppColors.accentGold,
                                          size: 20.sp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: markerPos.dx - 17.r,
                                top: markerPos.dy - 17.r,
                                child: _TrailMarker(
                                  fromIcon: _journeyIcon(widget.fromJourney),
                                  toIcon: _journeyIcon(widget.toJourney),
                                  progress: arcProgress.value,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 22.h),
                FadeTransition(
                  opacity: captionFade,
                  child: Text(
                    Keys.journeyTravelCaption.trParams({'journey': toTitle}),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// A gentle rising arc from bottom-left ("from") to top-right ("to").
  /// [startInset]/[endInset] are each label's measured width (plus a
  /// gap) — the line starts only after the "from" text ends and stops
  /// before the "to" text begins, so it can never run through either.
  Path _arcPath(Size size, double startInset, double endInset) {
    final start = Offset(startInset, size.height - 26.h);
    final end = Offset(size.width - endInset, 22.h);
    final control = Offset(size.width * 0.5, -10.h);
    return Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
  }

  /// Measures a label's rendered width with its real TextStyle, so layout
  /// reacts to actual content instead of a guessed fixed offset.
  double _labelWidth(String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.size.width;
  }
}

class _TalbiyahGlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.accentGold.withOpacity(0.22),
            AppColors.accentGold.withOpacity(0.0),
          ],
        ),
      ),
      child: Text(
        'লাব্বাইক',
        style: TextStyle(
          fontSize: 40.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.accentGold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _TrailMarker extends StatelessWidget {
  const _TrailMarker({
    required this.fromIcon,
    required this.toIcon,
    required this.progress,
  });

  final IconData fromIcon;
  final IconData toIcon;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.r,
      height: 34.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.accentGold,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGold.withOpacity(0.5),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      // The badge itself morphs from the departure icon to the arrival
      // icon as it crosses — it "becomes" what you're arriving at.
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: (1 - progress).clamp(0.0, 1.0),
            child: Icon(fromIcon, color: AppColors.primaryDark, size: 18.sp),
          ),
          Opacity(
            opacity: progress.clamp(0.0, 1.0),
            child: Icon(toIcon, color: AppColors.primaryDark, size: 18.sp),
          ),
        ],
      ),
    );
  }
}

/// Base path stays a dim thread; the portion already crossed lights up gold —
/// the same "traveled trail" language as the home page's chapter path.
class _ArcPathPainter extends CustomPainter {
  _ArcPathPainter({
    required this.path,
    required this.metric,
    required this.progress,
  });

  final Path path;
  final PathMetric metric;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, basePaint);

    if (progress > 0) {
      final traveled = metric.extractPath(0, metric.length * progress);
      final litPaint = Paint()
        ..color = AppColors.accentGold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(traveled, litPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ArcPathPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _StarFieldPainter extends CustomPainter {
  _StarFieldPainter(this.stars);
  final List<Offset> stars;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.16);
    for (final s in stars) {
      final r = (s.dx * 1.4).remainder(1.6) + 0.6;
      canvas.drawCircle(
        Offset(s.dx * size.width, s.dy * size.height),
        r,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarFieldPainter oldDelegate) => false;
}