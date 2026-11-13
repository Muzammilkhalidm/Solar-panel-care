/// Signed-in mobile user (customer / owner of the solar system).
class AppUser {
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    this.avatarColorIndex = 0,
  });

  final String id;
  String name;
  String email;
  String phone;
  final DateTime createdAt;
  final int avatarColorIndex;
}
