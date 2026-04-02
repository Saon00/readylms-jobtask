import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readylms_jobtask/core/values/app_icons.dart';
import 'package:readylms_jobtask/core/local_storage/hive_service.dart';
import '../../../core/values/colors.dart';
import '../../../core/values/app_fonts.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate based on onboarding status after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final hasSeenOnboarding = HiveService.hasSeenOnboarding();
        if (hasSeenOnboarding) {
          context.go('/welcome');
        } else {
          context.go('/onboarding');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientMiddle,
              AppColors.gradientEnd,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder for logo
              Image.asset(
                AppIcons.mortarboardLogo,
                width: 120.sp,
                height: 120.sp,
                // color: AppColors.white,
              ),
              SizedBox(height: 10.h),
              Text(
                'ReadyLMS',
                style: publicSansTextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
