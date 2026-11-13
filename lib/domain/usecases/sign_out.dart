import '../../data/repositories/auth_repository_impl.dart';

/// Clears the current session.
class SignOut {
  SignOut(this._repo);
  final AuthRepositoryImpl _repo;

  Future<void> execute() => _repo.signOut();
}
