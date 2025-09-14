import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/products/presentation/pages/product_list_page.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/home/presentation/pages/main_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState.user != null;
      final isLoading = authState.isLoading;
      final isOnAuthPages =
          state.matchedLocation == '/login' || state.matchedLocation == '/register';
      final isOnSplash = state.matchedLocation == '/splash';

      // Show splash while checking for cached user
      if (isLoading) {
        return '/splash';
      }

      // If user is on splash, redirect based on auth status
      if (isOnSplash) {
        return isLoggedIn ? '/' : '/login';
      }

      // If user is not logged in and not on auth pages, go to login
      if (!isLoggedIn && !isOnAuthPages) {
        return '/login';
      }

      // If user is logged in and on auth pages, go to home
      if (isLoggedIn && isOnAuthPages) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const ProductListPage(),
                routes: [
                  GoRoute(
                    path: 'product/:id',
                    builder: (context, state) {
                      final productId = int.parse(state.pathParameters['id']!);
                      return ProductDetailPage(productId: productId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                builder: (context, state) =>
                    const ProductListPage(showFavoritesOnly: true),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
