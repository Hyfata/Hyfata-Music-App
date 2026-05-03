import 'dart:async';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Stub implementation of [AuthRepository].
/// Always emits [Unauthenticated] so the UI can be built and tested.
/// Replace this with the real Hyfata OAuth + PKCE implementation later.
class AuthRepositoryImpl implements AuthRepository {
  final _controller = StreamController<AuthState>.broadcast();
  AuthState _currentState = const AuthInitial();

  AuthRepositoryImpl() {
    _controller.add(_currentState);
    // Simulate a brief loading then unauthenticated state
    Future.delayed(const Duration(milliseconds: 300), () {
      _currentState = const Unauthenticated();
      _controller.add(_currentState);
    });
  }

  @override
  Stream<AuthState> get authStateChanges => _controller.stream;

  @override
  AuthState get currentState => _currentState;

  @override
  Future<void> login() async {
    _currentState = const AuthLoading();
    _controller.add(_currentState);

    // TODO: Implement OAuth2 + PKCE flow
    // 1. Generate code_verifier & code_challenge
    // 2. Open browser/webview to Hyfata authorize endpoint
    // 3. Wait for deep-link callback -> handleAuthCallback

    await Future.delayed(const Duration(seconds: 1));

    // Stub: simulate successful login with a mock user
    final mockUser = UserEntity(
      id: 'stub-user-id',
      displayName: 'Hyfata Listener',
      email: 'listener@hyfata.example',
      avatarUrl: null,
    );
    _currentState = Authenticated(mockUser);
    _controller.add(_currentState);
  }

  @override
  Future<void> handleAuthCallback(String code) async {
    // TODO: Exchange code for tokens via token endpoint
  }

  @override
  Future<void> logout() async {
    _currentState = const AuthLoading();
    _controller.add(_currentState);

    // TODO: Clear secure storage, revoke tokens

    await Future.delayed(const Duration(milliseconds: 300));
    _currentState = const Unauthenticated();
    _controller.add(_currentState);
  }

  @override
  Future<String?> getAccessToken() async {
    // TODO: Return stored access token from secure storage
    return null;
  }

  @override
  Future<String?> refreshAccessToken() async {
    // TODO: Use refresh token to get new access token
    return null;
  }

  @override
  Future<void> registerPasskey() async {
    // TODO: Integrate platform passkey APIs (webauthn)
  }

  @override
  Future<void> authenticateWithPasskey() async {
    // TODO: Authenticate using stored passkey credential
  }

  void dispose() {
    _controller.close();
  }
}
