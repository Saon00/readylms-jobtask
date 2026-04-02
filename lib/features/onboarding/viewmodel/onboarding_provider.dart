import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readylms_jobtask/core/values/app_images.dart';

import '../model/onboarding_model.dart';

final onboardingProvider = NotifierProvider<OnboardingController, int>(
  OnboardingController.new,
);

class OnboardingController extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  final List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      title: 'Discover Top Courses',
      description: 'Explore thousands of courses from expert instructors',
      imagePath: AppImages.onboarding1,
    ),
    OnboardingModel(
      title: 'Learn Anytime, Anywhere',
      description: 'Access lessons on your schedule and track your progress',
      imagePath: AppImages.onboarding2,
    ),
    OnboardingModel(
      title: 'Teach & Share Your Knowledge',
      description: 'Create courses, reach students, and earn from your expertise.',
      imagePath: AppImages.onboarding3,
    ),
  ];

  void nextPage() {
    if (state < onboardingPages.length - 1) {
      state++;
    }
  }

  void previousPage() {
    if (state > 0) {
      state--;
    }
  }

  void skipToEnd() {
    state = onboardingPages.length - 1;
  }

  void setPage(int index) {
    state = index;
  }

  bool get isLastPage => state == onboardingPages.length - 1;
}
