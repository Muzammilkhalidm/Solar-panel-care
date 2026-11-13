/// Typed exceptions with user-friendly messages.
class AppException implements Exception {
  AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AuthException extends AppException {
  AuthException(super.message);
}

class StorageException extends AppException {
  StorageException(super.message);
}

class IotException extends AppException {
  IotException(super.message);
}

class ValidationException extends AppException {
  ValidationException(super.message);
}
