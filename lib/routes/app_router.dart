import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth/auth_state.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/wishlist_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/vr_tryon_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class AppRouter {
  static GoRouter createRouter(AuthState authState) {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final isAuth = authState is Authenticated;
        final isSplash = state.matchedLocation == '/';
        final isLogin = state.matchedLocation == '/login';

        if (authState is AuthInitial || authState is AuthLoading) {
          return null; // wait
        }

        if (!isAuth && !isLogin && !isSplash) {
          return '/login';
        }

        if (isAuth && (isLogin || isSplash)) {
          return '/home';
        }

        if (!isAuth && isSplash) {
          return '/login';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return Scaffold(
              body: child,
              bottomNavigationBar: BottomNavBar(
                currentIndex: _calculateSelectedIndex(state.matchedLocation),
                onTap: (index) {
                  switch (index) {
                    case 0:
                      context.go('/home');
                      break;
                    case 1:
                      context.go('/explore');
                      break;
                    case 2:
                      context.go('/cart');
                      break;
                    case 3:
                      context.go('/profile');
                      break;
                  }
                },
              ),
            );
          },
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/explore',
              builder: (context, state) => const ExploreScreen(),
            ),
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartScreen(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/wishlist',
          builder: (context, state) => const WishlistScreen(),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '1') ?? 1;
            return ProductDetailScreen(shoeId: id);
          },
        ),
        GoRoute(
          path: '/vr-tryon/:id',
          builder: (context, state) {
             final id = int.tryParse(state.pathParameters['id'] ?? '1') ?? 1;
             return VrTryOnScreen(shoeId: id);
          },
        ),
      ],
    );
  }

  static int _calculateSelectedIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/cart')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }
}
