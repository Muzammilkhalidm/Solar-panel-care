import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/logger.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/entities/app_user.dart';
import '../domain/usecases/sign_in.dart';
import '../domain/usecases/sign_out.dart';
import '../domain/usecases/sign_up.dart';

/// Session + local auth state.
class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required SignIn signIn,
    required SignUp signUp,
    required SignOut signOut,
    required AuthRepositoryImpl repository,
  })  : _signIn = signIn,
        _signUp = signUp,
        _signOut = signOut,
        _repository = repository;

  final SignIn _signIn;
  final SignUp _signUp;
  final SignOut _signOut;
  final AuthRepositoryImpl _repository;

  AppUser? user;
  bool loading = false;
  String? error;

  bool get isSignedIn => user != null;

  Future<void> loadSession() async {
    try {
      user = await _repository.currentUser();
    } catch (e) {
      AppLogger.e('Auth', 'loadSession failed', e);
      user = null;
    }
    notifyListeners();
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      user = await _signIn.execute(email: email, password: password);
      loading = false;
      AppLogger.i('Auth', 'Signed in as ${user!.email}');
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      user = await _signUp.execute(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
  }) async {
    await _repository.updateProfile(name: name, phone: phone);
    await loadSession();
  }

  Future<void> signOut() async {
    await _signOut.execute();
    user = null;
    notifyListeners();
  }

  // Convenience for the login screen hint card.
  static String get demoHint =>
      '${AppConstants.demoEmail}  /  ${AppConstants.demoPassword}';
}
