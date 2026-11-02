/// Base exception class for data sources.
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, [this.code]);

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, [super.code]);
}

class ServerException extends AppException {
  const ServerException(super.message, [super.code]);
}

class AuthException extends AppException {
  const AuthException(super.message, [super.code]);
}

class CacheException extends AppException {
  const CacheException(super.message, [super.code]);
}

class NotFoundException extends AppException {
  const NotFoundException(super.message, [super.code]);
}
