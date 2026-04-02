import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = NotifierProvider<LoginController, LoginState>(
  LoginController.new,
);

class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final bool isFormValid;

  LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.isFormValid = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isFormValid,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }
}

class LoginController extends Notifier<LoginState> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  LoginState build() {
    ref.onDispose(() {
      emailController.dispose();
      passwordController.dispose();
    });
    return LoginState();
  }

  bool validateForm() {
    if (formKey.currentState?.validate() ?? false) {
      state = state.copyWith(isFormValid: true, errorMessage: null);
      return true;
    } else {
      state = state.copyWith(
        isFormValid: false,
        errorMessage: 'Please fix the errors in the form',
      );
      return false;
    }
  }

  Future<bool> login() async {
    if (!validateForm()) {
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await Future.delayed(const Duration(seconds: 2));

      // // Simulate successful login
      // final email = emailController.text;
      // final password = passwordController.text;

      // Here you would call your authentication service
      // For now, just simulate success

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> loginWithApple() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // TODO: Implement Apple Sign In
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
