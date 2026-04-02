import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/validators.dart';
import '../../../core/values/app_fonts.dart';
import '../../../core/values/app_icons.dart';
import '../../../core/values/colors.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../viewmodel/login_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    final loginController = ref.read(loginProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
            child: Form(
              key: loginController.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Center(
                    child: Text(
                      'Log in With Email',
                      style: publicSansTextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),

                  // Subtitle
                  Center(
                    child: Text(
                      'Hello there, log in with your information',
                      style: publicSansTextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),

                  // Email Address Field
                  CustomTextField(
                    controller: loginController.emailController,
                    
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  SizedBox(height: 24.h),

                  // Password Field
                  CustomTextField(
                    controller: loginController.passwordController,
                    
                    hintText: 'Enter your password',
                    obscureText: true,
                    showPasswordToggle: true,
                    validator: Validators.validatePassword,
                  ),
                  SizedBox(height: 12.h),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Forgot password?',
                        style: publicSansTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.gradientMiddle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Log In Button
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: loginState.isLoading
                          ? null
                          : () async {
                              final success = await loginController.login();
                              if (context.mounted) {
                                if (success) {
                                  CustomDialog.showSuccess(
                                    context,
                                    'Login successful!',
                                    onPressed: () {
                                      context.go('/home');
                                    },
                                  );
                                } else if (loginState.errorMessage != null) {
                                  CustomDialog.showError(
                                    context,
                                    loginState.errorMessage!,
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gradientMiddle,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: loginState.isLoading
                          ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Log In',
                              style: publicSansTextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
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

                  // Continue with Google Button
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: OutlinedButton.icon(
                      onPressed: loginState.isLoading
                          ? null
                          : () async {
                              final success =
                                  await loginController.loginWithGoogle();
                              if (context.mounted && success) {
                                context.go('/home');
                              }
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
                  SizedBox(height: 32.h),

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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
