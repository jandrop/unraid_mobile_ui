import 'package:flutter_test/flutter_test.dart';
import 'package:unmobile/core/error/exceptions.dart';

void main() {
  group('AppException', () {
    test('should have message and status code', () {
      const exception = AppException('Test error', 500);
      expect(exception.message, 'Test error');
      expect(exception.statusCode, 500);
    });

    test('should have message without status code', () {
      const exception = AppException('Test error');
      expect(exception.message, 'Test error');
      expect(exception.statusCode, isNull);
    });

    test('toString should return message', () {
      const exception = AppException('Test error');
      expect(exception.toString(), 'Test error');
    });
  });

  group('ServerException', () {
    test('should have custom message and status code', () {
      const exception = ServerException('Internal server error', 500);
      expect(exception.message, 'Internal server error');
      expect(exception.statusCode, 500);
    });

    test('should have default message', () {
      const exception = ServerException();
      expect(exception.message, 'Server error');
      expect(exception.statusCode, isNull);
    });
  });

  group('NetworkException', () {
    test('should have custom message', () {
      const exception = NetworkException('Connection failed');
      expect(exception.message, 'Connection failed');
      expect(exception.statusCode, isNull);
    });

    test('should have default message', () {
      const exception = NetworkException();
      expect(exception.message, 'No internet connection');
    });
  });

  group('AuthenticationException', () {
    test('should have custom message and status code', () {
      const exception = AuthenticationException('Invalid token', 401);
      expect(exception.message, 'Invalid token');
      expect(exception.statusCode, 401);
    });

    test('should have default message', () {
      const exception = AuthenticationException();
      expect(exception.message, 'Authentication failed');
    });
  });

  group('AuthorizationException', () {
    test('should have custom message and status code', () {
      const exception = AuthorizationException('Access denied', 403);
      expect(exception.message, 'Access denied');
      expect(exception.statusCode, 403);
    });
  });

  group('NotFoundException', () {
    test('should have custom message and status code', () {
      const exception = NotFoundException('User not found', 404);
      expect(exception.message, 'User not found');
      expect(exception.statusCode, 404);
    });
  });

  group('ValidationException', () {
    test('should have custom message and status code', () {
      const exception = ValidationException('Invalid email', 400);
      expect(exception.message, 'Invalid email');
      expect(exception.statusCode, 400);
    });
  });

  group('TimeoutException', () {
    test('should have custom message', () {
      const exception = TimeoutException('Connection timeout');
      expect(exception.message, 'Connection timeout');
      expect(exception.statusCode, isNull);
    });
  });

  group('CacheException', () {
    test('should have custom message', () {
      const exception = CacheException('Cache write failed');
      expect(exception.message, 'Cache write failed');
      expect(exception.statusCode, isNull);
    });
  });

  group('ParseException', () {
    test('should have custom message', () {
      const exception = ParseException('JSON parse error');
      expect(exception.message, 'JSON parse error');
      expect(exception.statusCode, isNull);
    });
  });
}
