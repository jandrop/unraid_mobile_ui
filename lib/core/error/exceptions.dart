/// Base exception class for the application.
/// Thrown by data sources and caught by repositories.
class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// Exception for server errors (5xx)
class ServerException extends AppException {
  const ServerException([String message = 'Server error', int? statusCode])
      : super(message, statusCode);
}

/// Exception for network connectivity issues
class NetworkException extends AppException {
  const NetworkException([String message = 'No internet connection'])
      : super(message);
}

/// Exception for authentication errors (401)
class AuthenticationException extends AppException {
  const AuthenticationException([String message = 'Authentication failed', int? statusCode])
      : super(message, statusCode);
}

/// Exception for authorization errors (403)
class AuthorizationException extends AppException {
  const AuthorizationException([String message = 'Access forbidden', int? statusCode])
      : super(message, statusCode);
}

/// Exception for not found errors (404)
class NotFoundException extends AppException {
  const NotFoundException([String message = 'Resource not found', int? statusCode])
      : super(message, statusCode);
}

/// Exception for validation errors (400)
class ValidationException extends AppException {
  const ValidationException([String message = 'Invalid data', int? statusCode])
      : super(message, statusCode);
}

/// Exception for timeout errors
class TimeoutException extends AppException {
  const TimeoutException([String message = 'Request timeout'])
      : super(message);
}

/// Exception for cache operations
class CacheException extends AppException {
  const CacheException([String message = 'Cache error'])
      : super(message);
}

/// Exception for parsing/serialization errors
class ParseException extends AppException {
  const ParseException([String message = 'Failed to parse data'])
      : super(message);
}
