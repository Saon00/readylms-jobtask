
import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashProvider = NotifierProvider<SplashController, bool>(
  SplashController.new,
);

class SplashController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void navigateToOnboarding() {
    state = true;
  }
}
