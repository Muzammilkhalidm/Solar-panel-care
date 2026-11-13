import '../../domain/entities/app_user.dart';

/// JSON-mappable variant of [AppUser].
class UserModel extends AppUser {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.createdAt,
    super.avatarColorIndex,
  });

  factory UserModel.fromEntity(AppUser u) => UserModel(
        id: u.id,
        name: u.name,
        email: u.email,
        phone: u.phone,
        createdAt: u.createdAt,
        avatarColorIndex: u.avatarColorIndex,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'User',
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
              DateTime.now(),
      avatarColorIndex: json['avatarColorIndex'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': createdAt.toIso8601String(),
        'avatarColorIndex': avatarColorIndex,
      };

  static List<AppUser> listToEntity(List<dynamic> list) => list
      .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList();

  static List<Map<String, dynamic>> listFromEntity(List<AppUser> list) =>
      list.map((u) => UserModel.fromEntity(u).toJson()).toList();
}
