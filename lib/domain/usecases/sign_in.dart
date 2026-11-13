import '../../data/repositories/auth_repository_impl.dart';
import '../entities/app_user.dart';

/// Signs a user in with email + password.
class SignIn {
  SignIn(this._repo);
  final AuthRepositoryImpl _repo;

  Future<AppUser> execute({required String email, required String password}) =>
      _repo.signIn(email: email, password: password);
}
