import '../entities/app_user.dart';

/// Contract for local authentication.
abstract class AuthRepository {
  Future<AppUser?> currentUser();

  Future<AppUser> signIn({required String email, required String password});

  Future<AppUser> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<void> signOut();

  Future<void> updateProfile({required String name, required String phone});
}
