import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readylms_jobtask/core/values/dimens.dart';

import '../../../core/values/app_fonts.dart';
import '../../../core/values/colors.dart';
import '../viewmodel/role_provider.dart';

class RoleScreen extends ConsumerWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRole = ref.watch(roleProvider);
    final controller = ref.read(roleProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  'Choose Your Role',
                  style: publicSansTextStyle(
                    fontSize: 24.sp,

                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: AppDimens.xl_32.h+30),

              // Subtitle
              Text(
                'Select how you want to use the app',
                style: publicSansTextStyle(
                  fontSize: 16.sp,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 10.h),

              // Role Cards
              Expanded(
                child: ListView.builder(
                  itemCount: controller.roles.length,
                  itemBuilder: (context, index) {
                    final role = controller.roles[index];
                    final isSelected = selectedRole == role.id;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: GestureDetector(
                        onTap: () => controller.selectRole(role.id),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.gradientMiddle
                                  : AppColors.tealAccent.withOpacity(0.5),
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            color: AppColors.white,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 20.h,
                          ),
                          child: Row(
                            children: [
                              // Icon
                              Container(
                                padding: EdgeInsets.all(8),
                                width: 56.w,
                                height: 56.h,
                                decoration: BoxDecoration(
                                  color:  AppColors.gradientMiddle.withAlpha(100),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child:Image.asset(role.iconCodePoint, ),
                              ),
                              SizedBox(width: 16.w),

                              // Text Content 
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      role.name,
                                      style: publicSansTextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      role.description,
                                      style: publicSansTextStyle(
                                        fontSize: 12.sp,

                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),

                              // Checkmark
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.gradientMiddle,
                                  size: 24.sp,
                                )
                              else
                                SizedBox(width: 24.w),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: controller.isRoleSelected
                      ? () {
                          context.push('/welcome');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.isRoleSelected
                        ? AppColors.gradientMiddle
                        : AppColors.gradientMiddle.withOpacity(0.3),
                    disabledBackgroundColor:
                        AppColors.gradientMiddle.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: publicSansTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: controller.isRoleSelected
                          ? AppColors.white
                          : AppColors.white.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Decide Later Button
              Center(
                child: TextButton(
                  onPressed: controller.isRoleSelected
                      ? null
                      : () {
                          context.push('/welcome');
                        },
                  style: TextButton.styleFrom(
                    foregroundColor: controller.isRoleSelected
                        ? AppColors.grey.withOpacity(0.4)
                        : AppColors.textSecondary,
                  ),
                  child: Text(
                    'Decide later',
                    style: publicSansTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: controller.isRoleSelected
                          ? AppColors.grey.withOpacity(0.4)
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: publicSansTextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push('/welcome');
                    },
                    child: Text(
                      'Log In',
                      style: publicSansTextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}
