import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/services/tts_service.dart';
import '../../domain/entities/dua_content.dart';

/// A single dua: Arabic text large and RTL, Bangla transliteration, the
/// meaning (bn/en), and a play button that narrates it via TTS.
class DuaCard extends StatefulWidget {
  const DuaCard({super.key, required this.dua, required this.isBn});

  final DuaContent dua;
  final bool isBn;

  @override
  State<DuaCard> createState() => _DuaCardState();
}

class _DuaCardState extends State<DuaCard> {
  bool _isNarrating = false;

  Future<void> _toggleNarration() async {
    final tts = Get.find<TtsService>();
    if (_isNarrating) {
      await tts.stop();
      if (mounted) setState(() => _isNarrating = false);
      return;
    }

    final meaning = widget.isBn ? widget.dua.meaningBn : widget.dua.meaningEn;
    setState(() => _isNarrating = true);
    try {
      await tts.speak('${widget.dua.translitBn}. $meaning');
    } finally {
      if (mounted) setState(() => _isNarrating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dua = widget.dua;
    final isBn = widget.isBn;
    final meaning = isBn ? dua.meaningBn : dua.meaningEn;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TODO: bundle an Uthmanic/Amiri Arabic font and set fontFamily.
          Text(
            dua.arabic,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 26.sp,
              height: 1.6,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.paddingSm),
          Text(
            dua.translitBn,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.primary,
                  fontStyle: FontStyle.italic,
                ),
          ),
          SizedBox(height: 6.h),
          Text(meaning, style: Theme.of(context).textTheme.bodyMedium),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              // TODO: play dua.audioAsset (real recitation) once bundled.
              onPressed: _toggleNarration,
              icon: Icon(
                _isNarrating ? Icons.stop_circle : Icons.play_circle_fill,
              ),
              iconSize: 36.sp,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
