import '../entities/user_entity.dart';

/// Authentication states emitted by the repository.
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final UserEntity user;
  const Authenticated(this.user);
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

/// Abstract contract for Hyfata authentication.
/// Concrete implementations will handle OAuth2 + PKCE and Passkeys.
abstract class AuthRepository {
  /// Stream of authentication state changes.
  Stream<AuthState> get authStateChanges;

  /// Current cached state (synchronous).
  AuthState get currentState;

  /// Initiates the login flow (e.g., opens browser for OAuth).
  Future<void> login();

  /// Handles the OAuth redirect callback with authorization code.
  Future<void> handleAuthCallback(String code);

  /// Logs the user out and clears credentials.
  Future<void> logout();

  /// Returns the current access token if available.
  Future<String?> getAccessToken();

  /// Refreshes the access token using the refresh token.
  Future<String?> refreshAccessToken();

  /// Passkey registration stub.
  Future<void> registerPasskey();

  /// Passkey authentication stub.
  Future<void> authenticateWithPasskey();
}
