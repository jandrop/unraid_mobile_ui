import 'package:flutter_test/flutter_test.dart';
import 'package:unmobile/core/error/failures.dart';

void main() {
  group('Failure', () {
    test('ServerFailure should have correct message', () {
      const failure = ServerFailure('Custom server error');
      expect(failure.message, 'Custom server error');
    });

    test('ServerFailure should have default message', () {
      const failure = ServerFailure();
      expect(failure.message, 'Server error occurred');
    });

    test('NetworkFailure should have correct message', () {
      const failure = NetworkFailure('No connection');
      expect(failure.message, 'No connection');
    });

    test('AuthenticationFailure should have correct message', () {
      const failure = AuthenticationFailure('Invalid credentials');
      expect(failure.message, 'Invalid credentials');
    });

    test('ValidationFailure should have correct message', () {
      const failure = ValidationFailure('Invalid input');
      expect(failure.message, 'Invalid input');
    });

    test('NotFoundFailure should have correct message', () {
      const failure = NotFoundFailure('User not found');
      expect(failure.message, 'User not found');
    });

    test('CacheFailure should have correct message', () {
      const failure = CacheFailure('Cache miss');
      expect(failure.message, 'Cache miss');
    });

    test('TimeoutFailure should have correct message', () {
      const failure = TimeoutFailure('Connection timeout');
      expect(failure.message, 'Connection timeout');
    });

    test('UnexpectedFailure should have correct message', () {
      const failure = UnexpectedFailure('Something went wrong');
      expect(failure.message, 'Something went wrong');
    });

    test('Failures with same message should be equal', () {
      const failure1 = ServerFailure('Error');
      const failure2 = ServerFailure('Error');
      expect(failure1, equals(failure2));
    });

    test('Failures with different messages should not be equal', () {
      const failure1 = ServerFailure('Error 1');
      const failure2 = ServerFailure('Error 2');
      expect(failure1, isNot(equals(failure2)));
    });

    test('Different failure types should not be equal', () {
      const failure1 = ServerFailure('Error');
      const failure2 = NetworkFailure('Error');
      expect(failure1, isNot(equals(failure2)));
    });
  });
}
