import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/locale_keys.dart';
import '../../widgets/app_scaffold.dart';

/// Branded splash — shown briefly on every launch while
/// [SplashController] decides where to route next.
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TODO: replace with logo asset
              Icon(Icons.mosque, size: 72.sp, color: AppColors.primary),
              SizedBox(height: 20.h),
              Text(
                'লাব্বাইক',
                style: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Text(
                'Labbaik',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentGold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14.h),
              Text(
                Keys.appTagline.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
