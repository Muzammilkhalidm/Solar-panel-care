import '../../data/repositories/auth_repository_impl.dart';
import '../entities/app_user.dart';

/// Creates a new local account and signs the user in.
class SignUp {
  SignUp(this._repo);
  final AuthRepositoryImpl _repo;

  Future<AppUser> execute({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) =>
      _repo.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
}
