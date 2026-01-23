import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  const RegisterParams({required this.email, required this.password});

  final String email;
  final String password;
}

class RegisterUseCase {
  const RegisterUseCase(this.repository);

  final AuthRepository repository;

  Future<User> call(RegisterParams params) {
    return repository.login(email: params.email, password: params.password);
  }
}
