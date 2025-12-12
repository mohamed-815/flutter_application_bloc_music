import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api);

  final AuthApi _api;

  @override
  Future<User> login({required String email, required String password}) {
    return _api.login(email: email, password: password);
  }
}
