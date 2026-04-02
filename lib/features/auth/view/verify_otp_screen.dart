import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/values/app_fonts.dart';
import '../../../core/values/colors.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../viewmodel/otp_provider.dart';

class VerifyOTPScreen extends ConsumerWidget {
  final String? email;

  const VerifyOTPScreen({super.key, this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpState = ref.watch(otpProvider);
    final otpController = ref.read(otpProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
           
                // Title
                Center(
                  child: Text(
                    'Verify OTP',
                    style: publicSansTextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // Subtitle
                Center(
                  child: Text(
                    'Enter the 6-digit code sent to\n${email ?? "your phone"}',
                    textAlign: TextAlign.center,
                    style: publicSansTextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                SizedBox(height: 60.h),

                // OTP Input Fields
                LayoutBuilder(
                  builder: (context, constraints) {
                    final otpLength = OTPController.otpLength;
                    final gap = 10.w;

                    final maxWidth = constraints.maxWidth;
                    final totalGaps = gap * (otpLength - 1);
                    final available = (maxWidth - totalGaps).clamp(0, maxWidth);
                    final boxSize = (available / otpLength)
                        .clamp(42.0, 64.0)
                        .toDouble();

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(otpLength, (index) {
                        final hasValue =
                            otpController.otpControllers[index].text.isNotEmpty;
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == otpLength - 1 ? 0 : gap,
                          ),
                          child: Container(
                            width: boxSize,
                            height: boxSize,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: hasValue
                                    ? AppColors.gradientMiddle
                                    : AppColors.grey.withAlpha(77),
                                width: 2.w,
                              ),
                              boxShadow: [
                                if (hasValue)
                                  BoxShadow(
                                    color: AppColors.gradientMiddle.withAlpha(
                                      26,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: TextField(
                              controller: otpController.otpControllers[index],
                              focusNode: otpController.focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: publicSansTextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              onChanged: (value) {
                                otpController.onOTPChanged(index, value);
                              },
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
                SizedBox(height: 40.h),

                // Resend Code with Timer
                Center(
                  child: Column(
                    children: [
                      if (otpState.remainingTime > 0) ...[
                        Text(
                          'Resend code in ${otpState.remainingTime}s',
                          style: publicSansTextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ] else ...[
                        TextButton(
                          onPressed: otpState.isLoading
                              ? null
                              : () async {
                                  final success = await otpController
                                      .resendOTP();
                                  if (context.mounted && success) {
                                    CustomDialog.showSuccess(
                                      context,
                                      'OTP has been resent to ${email ?? "your phone"}',
                                    );
                                  }
                                },
                          child: RichText(
                            text: TextSpan(
                              text: 'Didn\’t receive it? Try again ',
                              style: publicSansTextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textSecondary,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Resend OTP',
                                  style: publicSansTextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.gradientMiddle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 40.h),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: otpState.isLoading
                        ? null
                        : () async {
                            final success = await otpController.verifyOTP();
                            if (context.mounted) {
                              if (success) {
                                context.push('/verification-success');
                              } else if (otpState.errorMessage != null) {
                                CustomDialog.showError(
                                  context,
                                  otpState.errorMessage!,
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gradientMiddle,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      disabledBackgroundColor: AppColors.grey.withOpacity(0.3),
                    ),
                    child: otpState.isLoading
                        ? SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Next',
                            style: publicSansTextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
