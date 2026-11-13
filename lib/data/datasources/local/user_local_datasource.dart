import 'dart:convert';

import '../../../core/utils/logger.dart';
import '../../models/user_model.dart';
import 'local_database.dart';
import '../../../domain/entities/app_user.dart';

/// Local user accounts + current session.
class UserLocalDatasource {
  UserLocalDatasource(this._db);

  final LocalDatabase _db;

  Future<List<AppUser>?> loadUsers() async {
    try {
      final String? raw = _db.read(LocalDatabase.kUsers);
      if (raw == null || raw.isEmpty) return null;
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return UserModel.listToEntity(list);
    } catch (e) {
      AppLogger.e('UserLocalDS', 'Failed to load users', e);
      return null;
    }
  }

  Future<void> saveUsers(List<AppUser> users) async {
    try {
      final String raw = jsonEncode(UserModel.listFromEntity(users));
      await _db.write(LocalDatabase.kUsers, raw);
    } catch (e) {
      AppLogger.e('UserLocalDS', 'Failed to save users', e);
    }
  }

  Future<String?> readSession() async {
    return _db.read(LocalDatabase.kSession);
  }

  Future<void> writeSession(String email) async {
    await _db.write(LocalDatabase.kSession, email);
  }

  Future<void> clearSession() async {
    await _db.remove(LocalDatabase.kSession);
  }
}
