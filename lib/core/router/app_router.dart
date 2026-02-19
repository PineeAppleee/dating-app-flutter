import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/profile_onboarding_screen.dart';
import '../../features/home/presentation/screens/main_screen.dart';
import '../../features/discover/presentation/screens/discover_screen.dart';
import '../../features/matches/presentation/screens/matches_screen.dart';
import '../../features/likes/presentation/screens/likes_screen.dart';
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/chat/presentation/screens/chat_detail_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/full_profile_screen.dart';
import '../../core/utils/mock_data.dart'; // For User Model

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/profile_setup',
        builder: (context, state) => const ProfileOnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/discover',
            builder: (context, state) => const DiscoverScreen(),
            routes: [
              GoRoute(
                path: 'profile',
                builder: (context, state) {
                   final user = state.extra as UserModel;
                   return FullProfileScreen(user: user);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/chats',
            builder: (context, state) => const ChatListScreen(),
            routes: [
              GoRoute(
                path: 'detail',
                builder: (context, state) {
                  final user = state.extra as UserModel;
                  return ChatDetailScreen(user: user);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/matches',
            builder: (context, state) => const MatchesScreen(),
          ),
          GoRoute(
            path: '/likes',
            builder: (context, state) => const LikesScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
