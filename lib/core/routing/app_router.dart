import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_controller.dart';
import '../../features/auth/otp_verification_screen.dart';
import '../../features/auth/phone_login_screen.dart';
import '../../features/auth/profile_setup_screen.dart';
import '../../features/auth/user_profile_screen.dart';
import '../../features/auth/welcome_screen.dart';
import '../../features/case_brief/case_brief_screen.dart';
import '../../features/cases/case_detail_screen.dart';
import '../../features/cases/cases_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/research/research_detail_screen.dart';
import '../../features/saved/saved_screen.dart';
import 'main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/welcome',
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final path = state.matchedLocation;

      // Auth screens
      if (auth.status == AuthStatus.unauthenticated &&
          !path.startsWith('/welcome') &&
          !path.startsWith('/login')) {
        return '/welcome';
      }
      if (auth.status == AuthStatus.verifying && path != '/otp') {
        return '/otp';
      }
      if (auth.status == AuthStatus.profileSetup && path != '/profile-setup') {
        return '/profile-setup';
      }
      // Authenticated or guest — don't let them see auth screens
      if ((auth.status == AuthStatus.authenticated ||
              auth.status == AuthStatus.guest) &&
          (path.startsWith('/welcome') ||
              path == '/login' ||
              path == '/otp' ||
              path == '/profile-setup')) {
        return '/';
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(ref, authControllerProvider),
    routes: [
      // ── Auth flow ──────────────────────────────────────────────
      GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/login', builder: (_, __) => const PhoneLoginScreen()),
      GoRoute(path: '/otp', builder: (_, __) => const OtpVerificationScreen()),
      GoRoute(
        path: '/profile-setup',
        builder: (_, __) => const ProfileSetupScreen(),
      ),
      GoRoute(path: '/profile', builder: (_, __) => const UserProfileScreen()),

      // ── Main tab shell ─────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/ask', builder: (_, __) => const ChatScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/cases', builder: (_, __) => const CasesScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/saved', builder: (_, __) => const SavedScreen()),
          ]),
        ],
      ),

      // ── Detail routes ──────────────────────────────────────────
      GoRoute(
        path: '/case/:id',
        builder: (_, s) => CaseDetailScreen(caseId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/research/:id',
        builder: (_, s) =>
            ResearchDetailScreen(itemId: s.pathParameters['id']!),
      ),
      GoRoute(path: '/brief', builder: (_, __) => const CaseBriefScreen()),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('Page not found')),
    ),
  );
});

/// Bridges Riverpod state changes to GoRouter's Listenable refresh.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Ref ref, ProviderListenable<dynamic> provider) {
    ref.listen(provider, (_, __) => notifyListeners());
  }
}
