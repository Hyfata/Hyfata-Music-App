import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/extensions/context_extensions.dart';
import '../../domain/repositories/auth_repository.dart';
import '../providers/auth_provider.dart';

/// Profile page showing user info and login/logout actions.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textStyles = context.appTextStyles;
    final authAsync = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: textStyles.pageTitle.copyWith(fontSize: 22)),
        centerTitle: true,
      ),
      body: Center(
        child: authAsync.when(
          data: (authState) {
            if (authState is Authenticated) {
              final user = authState.user;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: colors.primary.withValues(alpha: 0.2),
                    backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                    child: user.avatarUrl == null
                        ? Icon(Icons.person, size: 48, color: colors.primary)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(user.displayName, style: textStyles.sectionHeader),
                  if (user.email != null)
                    Text(user.email!, style: textStyles.caption),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Log Out'),
                  ),
                ],
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: colors.surfaceVariant,
                  child: Icon(Icons.person_outline, size: 48, color: colors.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                Text('Guest', style: textStyles.sectionHeader),
                const SizedBox(height: 8),
                Text('Sign in to sync your playlists and friends.', style: textStyles.caption),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => ref.read(authNotifierProvider.notifier).login(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Sign In with Hyfata'),
                ),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, _) => Text('Error: $err', style: textStyles.body),
        ),
      ),
    );
  }
}
