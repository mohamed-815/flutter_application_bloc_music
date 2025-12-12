import '../../domain/entities/user.dart';

/// Fake API layer to simulate authentication.
class AuthApi {
  Future<User> login({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    // In a real implementation, perform HTTP request and handle errors.
    if (email.isEmpty || password.isEmpty) {
      throw const AuthException('Email and password are required.');
    }

    if (password.length < 4) {
      throw const AuthException('Password is too short.');
    }

    return User(email: email);
  }
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
}
// ssgskkkflknfndflk