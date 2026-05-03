import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

/// Provider for the concrete [AuthRepository] implementation.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final repo = AuthRepositoryImpl();
  ref.onDispose(repo.dispose);
  return repo;
});

/// Stream provider that exposes auth state changes to the UI.
final authStateProvider = StreamProvider<AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

/// Synchronous provider for the latest known auth state.
final authStateSyncProvider = Provider<AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.currentState;
});

/// Notifier for auth actions (login / logout).
class AuthNotifier extends StateNotifier<AsyncValue<AuthState>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.loading()) {
    _repository.authStateChanges.listen((authState) {
      state = AsyncValue.data(authState);
    });
  }

  Future<void> login() async {
    state = const AsyncValue.loading();
    try {
      await _repository.login();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _repository.logout();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthState>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
