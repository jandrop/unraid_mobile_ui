import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
/// Used with Either type for functional error handling.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure for server-related errors
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred'])
      : super(message);
}

/// Failure for network connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network connection failed'])
      : super(message);
}

/// Failure for authentication/authorization errors
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([String message = 'Authentication failed'])
      : super(message);
}

/// Failure for invalid data or validation errors
class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation failed'])
      : super(message);
}

/// Failure for data not found errors
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Resource not found'])
      : super(message);
}

/// Failure for storage/cache errors
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache operation failed'])
      : super(message);
}

/// Failure for timeout errors
class TimeoutFailure extends Failure {
  const TimeoutFailure([String message = 'Request timeout']) : super(message);
}

/// Generic failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([String message = 'An unexpected error occurred'])
      : super(message);
}
