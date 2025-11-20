import 'package:dartz/dartz.dart';
import 'package:unmobile/core/error/failures.dart';

/// Base class for all use cases
/// Implements the Execute Around pattern
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Used for use cases that don't require parameters
class NoParams {
  const NoParams();
}
