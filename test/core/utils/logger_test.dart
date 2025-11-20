import 'package:flutter_test/flutter_test.dart';
import 'package:unmobile/core/utils/logger.dart';

void main() {
  group('AppLogger', () {
    late AppLogger logger;

    setUp(() {
      logger = AppLogger();
    });

    test('should create logger instance', () {
      expect(logger, isNotNull);
    });

    test('should log debug messages without throwing', () {
      expect(() => logger.debug('Debug message'), returnsNormally);
    });

    test('should log info messages without throwing', () {
      expect(() => logger.info('Info message'), returnsNormally);
    });

    test('should log warning messages without throwing', () {
      expect(() => logger.warning('Warning message'), returnsNormally);
    });

    test('should log error messages without throwing', () {
      expect(() => logger.error('Error message'), returnsNormally);
    });

    test('should log fatal messages without throwing', () {
      expect(() => logger.fatal('Fatal message'), returnsNormally);
    });

    test('should log messages with error and stack trace', () {
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;

      expect(
        () => logger.error('Error with details', error, stackTrace),
        returnsNormally,
      );
    });
  });
}
