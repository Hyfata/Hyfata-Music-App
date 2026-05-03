import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/router/app_router.dart';

/// Root widget of the application.
/// Configures Riverpod, theme, and go_router.
class HyfataMusicApp extends ConsumerWidget {
  const HyfataMusicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Hyfata Music',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData(Brightness.light),
      darkTheme: AppTheme.themeData(Brightness.dark),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
