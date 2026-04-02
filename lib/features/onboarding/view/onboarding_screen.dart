import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/values/colors.dart';
import '../../../core/values/app_fonts.dart';
import '../../../core/local_storage/hive_service.dart';
import '../viewmodel/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(onboardingProvider);
    final controller = ref.read(onboardingProvider.notifier);
    final pages = controller.onboardingPages;

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
                child: controller.isLastPage
                    ? const SizedBox.shrink()
                    : Container(
                        decoration: BoxDecoration(
                          color: AppColors.skipButtonBg.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(17.r),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _pageController.jumpToPage(pages.length - 1);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              // vertical: 5.h,
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

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  controller.setPage(index);
                },
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image/Icon Placeholder
                        pages[index].imagePath != null
                            ? Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                              child: SvgPicture.asset(
                                  pages[index].imagePath!,
                                  fit: BoxFit.contain,
                                ),
                            )
                            : Container(
                                width: 280.w,
                                height: 280.h,
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child:Icon(
                                  Icons.menu_book,
                                  size: 120.sp,
                                  color: AppColors.gradientMiddle.withOpacity(0.6),
                                )
                              
                        ),
                        SizedBox(height: 50.h),

                        // Title
                        Text(
                          pages[index].title,
                          textAlign: TextAlign.center,
                          style: publicSansTextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.gradientMiddle,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Description
                        Text(
                          pages[index].description,
                          textAlign: TextAlign.center,
                          style: publicSansTextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                            // lineHeight: 1.6,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom section with indicator and button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
              child: SizedBox(
                height: 64.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Page Indicator (centered)
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: pages.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 8.h,
                        dotWidth: 8.w,
                        expansionFactor: 3,
                        spacing: 8.w,
                        activeDotColor: AppColors.gradientMiddle,
                        dotColor: AppColors.gradientMiddle.withOpacity(0.25),
                      ),
                    ),

                    // Circular Next Button (right)
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          if (controller.isLastPage) {
                            // Mark onboarding as seen before navigating
                            await HiveService.setOnboardingSeen();
                            context.go('/role');
                            return;
                          }

                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          width: 64.w,
                          height: 64.h,
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.gradientMiddle,
                              width: 2.w,
                            ),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.gradientMiddle,
                                  AppColors.gradientStart,
                                ],
                              ),
                            ),
                            child: Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.white,
                              size: 34.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
