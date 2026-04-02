import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/values/app_fonts.dart';
import '../../../core/values/app_icons.dart';
import '../../../core/values/colors.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.skipButtonBg.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(17.r),
                  ),
                  child: TextButton(
                    onPressed: () {
                       context.push('/login');
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                      ),
                    ),
                    child: Text(
                      'Skip',
                      style: publicSansTextStyle(
                        fontSize: 16,
                        color: AppColors.gradientMiddle,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),

                      // Logo
                      Image.asset(
                        AppIcons.mortarboardLogo,
                        width: 100.w,
                        height: 100.h,
                      ),
                      SizedBox(height: 32.h),

                      // Welcome Back Title
                      Text(
                        'Welcome Back!',
                        style: publicSansTextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Subtitle
                      Text(
                        'Hello there, how would you like to continue',
                        textAlign: TextAlign.center,
                        style: publicSansTextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // Continue with Google Button
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: OutlinedButton.icon(
                          onPressed: () {
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.grey.withOpacity(0.3),
                              width: 1.5.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            backgroundColor: AppColors.white,
                          ),
                          icon: SvgPicture.asset(
                            AppIcons.googleLogo,
                            width: 24.w,
                            height: 24.h,
                          ),
                          label: Text(
                            'Continue with Google',
                            style: publicSansTextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Continue with Apple Button
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: OutlinedButton.icon(
                          onPressed: () {
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.grey.withOpacity(0.3),
                              width: 1.5.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            backgroundColor: AppColors.white,
                          ),
                          icon: SvgPicture.asset(
                            AppIcons.appleLogo,
                            width: 24.w,
                            height: 24.h,
                          ),
                          label: Text(
                            'Continue with Apple',
                            style: publicSansTextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Or Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppColors.grey.withOpacity(0.3),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              'Or',
                              style: publicSansTextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.grey.withOpacity(0.3),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Log In With Email Button
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: () {
                            context.push('/login');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gradientMiddle,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'Log In With Email',
                            style: publicSansTextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Sign Up Text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: publicSansTextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push('/signup');
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                            ),
                            child: Text(
                              'Sign Up',
                              style: publicSansTextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.gradientMiddle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
