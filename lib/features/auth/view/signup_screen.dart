import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/validators.dart';
import '../../../core/values/app_fonts.dart';
import '../../../core/values/colors.dart';
import '../../../core/widgets/country_picker_dialog.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button_widget.dart';
import '../viewmodel/signup_provider.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpProvider);
    final signUpController = ref.read(signUpProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 22.h),
            child: Form(
              key: signUpController.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Center(
                    child: Text(
                      'Sign Up',
                      style: publicSansTextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 28.h),

                  // Full Name Field
                  CustomTextField(
                    controller: signUpController.nameController,
                    hintText: 'Full name',
                    keyboardType: TextInputType.name,
                    validator: Validators.validateName,
                  ),
                  SizedBox(height: 16.h),

                  // Email Address Field
                  CustomTextField(
                    controller: signUpController.emailController,
                    hintText: 'Email address',
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  SizedBox(height: 16.h),

                  // Phone Field
                  _PhoneField(
                    selectedCountry: signUpState.selectedCountry,
                    controller: signUpController.phoneController,
                    onPickCountry: () async {
                      final selected = await showDialog<Country>(
                        context: context,
                        builder: (context) => CountryPickerDialog(
                          initial: signUpState.selectedCountry,
                        ),
                      );
                      if (selected != null) {
                        signUpController.updateCountry(selected);
                      }
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Password Field
                  CustomTextField(
                    controller: signUpController.passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    showPasswordToggle: true,
                    validator: Validators.validatePassword,
                  ),

                  SizedBox(height: 14.h),

                  // Terms
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Checkbox(
                          value: signUpState.acceptedTerms,
                          onChanged: (v) =>
                              signUpController.setAcceptedTerms(v ?? false),
                          activeColor: AppColors.gradientMiddle,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                            vertical: -4,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: publicSansTextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              const TextSpan(
                                text:
                                    'By registering, I confirm that I accept ShowMe\'s ',
                              ),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style:
                                    publicSansTextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ).copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                              const TextSpan(text: ', and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style:
                                    publicSansTextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ).copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 26.h),

                  // Sign Up Button
                  CustomButtonWidget(
                    label: 'Sign up',
                    radius: 14.r,
                    isLoading: signUpState.isLoading,
                    onPressed: () async {
                      final success = await signUpController.signUp();
                      if (!context.mounted) return;
                      if (success) {
                        final target = signUpController.getOtpTarget();
                        context.push('/verify-otp', extra: target);
                        return;
                      }
                    },
                  ),

                  SizedBox(height: 34.h),

                  // Footer
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
                          context.go('/login');
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                        ),
                        child: Text(
                          'Log In',
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

class _PhoneField extends StatelessWidget {
  final Country selectedCountry;
  final TextEditingController controller;
  final VoidCallback onPickCountry;

  const _PhoneField({
    required this.selectedCountry,
    required this.controller,
    required this.onPickCountry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey.withAlpha(77), width: 1.5.w),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onPickCountry,
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 18.w,
                    height: 18.w,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      selectedCountry.flag,
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    selectedCountry.dialCode,
                    style: publicSansTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18.sp,
                    color: AppColors.grey,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 1.w,
            height: 28.h,
            color: AppColors.grey.withAlpha(77),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: Validators.validatePhone,
              decoration: InputDecoration(
                hintText: '0000000000',
                hintStyle: publicSansTextStyle(
                  fontSize: 14.sp,
                  color: AppColors.grey,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.only(right: 12.w),
              ),
              style: publicSansTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
