import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readylms_jobtask/features/auth/view/login_screen.dart';
import 'package:readylms_jobtask/features/auth/view/signup_screen.dart';
import 'package:readylms_jobtask/features/auth/view/verification_success_screen.dart';
import 'package:readylms_jobtask/features/auth/view/verify_otp_screen.dart';
import 'package:readylms_jobtask/features/auth/view/welcome_screen.dart';
import 'package:readylms_jobtask/features/home/view/home_screen.dart';
import 'package:readylms_jobtask/features/onboarding/view/onboarding_screen.dart';
import 'package:readylms_jobtask/features/onboarding/view/splash_screen.dart';
import 'package:readylms_jobtask/features/role/view/role_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/role',
        name: 'role',
        builder: (context, state) => const RoleScreen(),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/verify-otp',
        name: 'verify-otp',
        builder: (context, state) {
          final email = state.extra as String?;
          return VerifyOTPScreen(email: email);
        },
      ),
      GoRoute(
        path: '/verification-success',
        name: 'verification-success',
        builder: (context, state) => const VerificationSuccessScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
    debugLogDiagnostics: true,
  );
});
