import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;
}

class LoginUseCase {
  const LoginUseCase(this.repository);

  final AuthRepository repository;

  Future<User> call(LoginParams params) {
    return repository.login(email: params.email, password: params.password);
  }
}
