import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../shell/adaptive_scaffold.dart';
import '../pages/home_page.dart';
import '../pages/search_page.dart';
import '../pages/playlists_page.dart';
import '../pages/settings_page.dart';
import '../pages/profile_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRoutes {
  static const String home = '/';
  static const String search = '/search';
  static const String playlists = '/playlists';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String authCallback = '/auth/callback';
}

/// App router configuration using go_router.
/// The AdaptiveScaffold wraps all main routes to provide persistent
/// navigation chrome (sidebar on desktop, bottom bar on mobile).
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AdaptiveScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const HomePage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.search,
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const SearchPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.playlists,
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const PlaylistsPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.settings,
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const SettingsPage(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.profile,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ProfilePage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.authCallback,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        // code parameter extracted for OAuth callback
        // TODO: Handle OAuth callback
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    ),
  ],
);
