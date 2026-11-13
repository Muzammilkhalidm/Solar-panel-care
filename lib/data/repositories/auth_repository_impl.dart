import '../../core/constants/app_constants.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/local_database.dart';
import '../datasources/local/user_local_datasource.dart';

/// Local (offline) authentication. Users live in SharedPreferences —
/// perfect for a demo / final-year project, swappable with Firebase Auth.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._userDs, this._db);

  final UserLocalDatasource _userDs;
  final LocalDatabase _db;

  List<AppUser>? _cache;

  Future<List<AppUser>> _users() async {
    if (_cache != null) return _cache!;
    final List<AppUser>? stored = await _userDs.loadUsers();
    if (stored != null && stored.isNotEmpty) {
      _cache = stored;
    } else {
      _cache = [
        AppUser(
          id: 'USR-001',
          name: AppConstants.demoUserName,
          email: AppConstants.demoEmail,
          phone: '+92 300 1234567',
          createdAt: DateTime.now().subtract(const Duration(days: 240)),
          avatarColorIndex: 0,
        ),
      ];
      await _userDs.saveUsers(_cache!);
    }
    return _cache!;
  }

  @override
  Future<AppUser?> currentUser() async {
    final String? email = await _userDs.readSession();
    if (email == null) return null;
    final List<AppUser> users = await _users();
    for (final AppUser u in users) {
      if (u.email.toLowerCase() == email.toLowerCase()) return u;
    }
    return null;
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final List<AppUser> users = await _users();
    final String mail = email.trim().toLowerCase();

    // Demo account auto-provisions with its fixed password.
    if (mail == AppConstants.demoEmail) {
      if (password != AppConstants.demoPassword) {
        throw AuthExceptionMessage('Incorrect password for the demo account.');
      }
      await _userDs.writeSession(users.first.email);
      return users.first;
    }

    for (final AppUser u in users) {
      if (u.email.toLowerCase() == mail) {
        // NOTE: plain-text comparison is for the local demo only.
        final String? stored = _db.read(_pwdKey(mail));
        final String expected = stored ?? AppConstants.demoPassword;
        if (password != expected) {
          throw AuthExceptionMessage('Incorrect password.');
        }
        await _userDs.writeSession(u.email);
        return u;
      }
    }
    throw AuthExceptionMessage(
        'No account found for this email. Register first or use the demo login.');
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final List<AppUser> users = await _users();
    final String mail = email.trim().toLowerCase();
    for (final AppUser u in users) {
      if (u.email.toLowerCase() == mail) {
        throw AuthExceptionMessage('This email is already registered.');
      }
    }
    final AppUser user = AppUser(
      id: 'USR-${(users.length + 1).toString().padLeft(3, '0')}',
      name: name.trim(),
      email: mail,
      phone: phone.trim(),
      createdAt: DateTime.now(),
      avatarColorIndex: users.length % 5,
    );
    users.add(user);
    await _userDs.saveUsers(users);
    await _db.write(_pwdKey(mail), password);
    await _userDs.writeSession(mail);
    AppLogger.i('AuthRepo', 'Registered ${user.email}');
    return user;
  }

  @override
  Future<void> signOut() => _userDs.clearSession();

  @override
  Future<void> updateProfile({
    required String name,
    required String phone,
  }) async {
    final AppUser? current = await currentUser();
    if (current == null || _cache == null) return;
    current.name = name.trim();
    current.phone = phone.trim();
    await _userDs.saveUsers(_cache!);
  }

  String _pwdKey(String mail) => 'pwd_${mail.hashCode.abs()}';
}

/// Local exception with a user-friendly message.
class AuthExceptionMessage implements Exception {
  AuthExceptionMessage(this.message);
  final String message;

  @override
  String toString() => message;
}
