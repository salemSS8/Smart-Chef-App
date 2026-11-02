/// Base failure class for Clean Architecture domain layer.
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

/// Failure representing local SQLite/Drift database errors.
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, [super.code]);
}

/// Failure representing network, API, or Supabase backend errors.
class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.code]);
}

/// Failure representing user authentication and authorization issues.
class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.code]);
}

/// Failure representing offline connectivity or cache misses.
class CacheFailure extends Failure {
  const CacheFailure(super.message, [super.code]);
}

/// Failure representing invalid user inputs or validation rejections.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.code]);
}

/// Failure when requested entity or resource is not found.
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, [super.code]);
}
