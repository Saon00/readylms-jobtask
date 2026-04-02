import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final otpProvider = NotifierProvider<OTPController, OTPState>(
  OTPController.new,
);

class OTPState {
  final bool isLoading;
  final String? errorMessage;
  final bool isOTPComplete;
  final bool canResend;
  final int remainingTime;

  OTPState({
    this.isLoading = false,
    this.errorMessage,
    this.isOTPComplete = false,
    this.canResend = false,
    this.remainingTime = 60,
  });

  OTPState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isOTPComplete,
    bool? canResend,
    int? remainingTime,
  }) {
    return OTPState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isOTPComplete: isOTPComplete ?? this.isOTPComplete,
      canResend: canResend ?? this.canResend,
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }
}

class OTPController extends Notifier<OTPState> {
  static const int otpLength = 6;

  final List<TextEditingController> otpControllers = List.generate(
    otpLength,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(
    otpLength,
    (index) => FocusNode(),
  );

  Timer? _timer;

  @override
  OTPState build() {
    ref.onDispose(() {
      _timer?.cancel();
      for (var controller in otpControllers) {
        controller.dispose();
      }
      for (var focusNode in focusNodes) {
        focusNode.dispose();
      }
    });

    // Riverpod rule: don't read/write `state` synchronously in `build()`.
    // Start the timer after the provider has finished initializing.
    Future.microtask(() {
      if (!ref.mounted) return;
      _startTimer();
    });

    return OTPState();
  }

  void _startTimer() {
    state = state.copyWith(remainingTime: 60, canResend: false);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime > 0) {
        state = state.copyWith(remainingTime: state.remainingTime - 1);
      } else {
        state = state.copyWith(canResend: true);
        timer.cancel();
      }
    });
  }

  void onOTPChanged(int index, String value) {
    if (value.isNotEmpty && index < otpLength - 1) {
      // Move to next field
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      // Move to previous field
      focusNodes[index - 1].requestFocus();
    }

    // Check if OTP is complete
    checkOTPComplete();
  }

  void checkOTPComplete() {
    final isComplete = otpControllers.every(
      (controller) => controller.text.isNotEmpty,
    );
    state = state.copyWith(isOTPComplete: isComplete);
  }

  String getOTP() {
    return otpControllers.map((controller) => controller.text).join();
  }

  bool validateOTP() {
    final otp = getOTP();

    if (otp.length != otpLength) {
      state = state.copyWith(errorMessage: 'Please enter all 6 digits');
      return false;
    }

    state = state.copyWith(errorMessage: null);
    return true;
  }

  Future<bool> verifyOTP() async {
    if (!validateOTP()) {
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final otp = getOTP();
      await Future.delayed(const Duration(seconds: 2));

      debugPrint('Verifying OTP: $otp');

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid OTP. Please try again.',
      );
      return false;
    }
  }

  Future<bool> resendOTP() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await Future.delayed(const Duration(seconds: 2));

      debugPrint('Resending OTP');

      clearOTP();
      _startTimer();

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  void clearOTP() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    if (focusNodes.isNotEmpty) {
      focusNodes[0].requestFocus();
    }
    state = state.copyWith(isOTPComplete: false);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
