import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/country_picker_dialog.dart';
import '../../../core/local_storage/hive_service.dart';

final signUpProvider = NotifierProvider<SignUpController, SignUpState>(
  SignUpController.new,
);

class SignUpState {
  final bool isLoading;
  final String? errorMessage;
  final bool isFormValid;
  final String? email;
  final String? phone;
  final Country selectedCountry;
  final bool acceptedTerms;

  SignUpState({
    this.isLoading = false,
    this.errorMessage,
    this.isFormValid = false,
    this.email,
    this.phone,
    Country? selectedCountry,
    this.acceptedTerms = false,
  }) : selectedCountry = selectedCountry ?? Country.defaultCountry();

  SignUpState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isFormValid,
    String? email,
    String? phone,
    Country? selectedCountry,
    bool? acceptedTerms,
  }) {
    return SignUpState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isFormValid: isFormValid ?? this.isFormValid,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
    );
  }
}

class SignUpController extends Notifier<SignUpState> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  SignUpState build() {
    ref.onDispose(() {
      nameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      passwordController.dispose();
    });
    return SignUpState();
  }

  bool validateForm() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      state = state.copyWith(
        isFormValid: false,
        errorMessage: 'Please fix the errors in the form',
      );
      return false;
    }

    if (!state.acceptedTerms) {
      state = state.copyWith(
        isFormValid: false,
        errorMessage: 'Please accept Terms & Conditions',
      );
      return false;
    }

    state = state.copyWith(isFormValid: true, errorMessage: null);
    return true;
  }

  void updateCountry(Country country) {
    state = state.copyWith(selectedCountry: country);
  }

  void setAcceptedTerms(bool value) {
    state = state.copyWith(acceptedTerms: value, errorMessage: null);
  }

  String getFullPhoneNumber() {
    return '${state.selectedCountry.dialCode}${phoneController.text.trim()}';
  }

  Future<bool> signUp() async {
    if (!validateForm()) {
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await Future.delayed(const Duration(seconds: 2));

      final name = nameController.text;
      final email = emailController.text;
      final phone = getFullPhoneNumber();

      await HiveService.setUserName(name);

      state = state.copyWith(isLoading: false, email: email, phone: phone);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> signUpWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  String? getEmail() {
    return state.email ?? emailController.text;
  }

  String? getPhone() {
    return state.phone;
  }

  String getOtpTarget() {
    final phone = getPhone();
    if (phone != null && phone.trim().isNotEmpty) return phone;
    return getEmail() ?? '';
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
