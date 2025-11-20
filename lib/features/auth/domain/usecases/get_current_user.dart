import 'package:dartz/dartz.dart';
import 'package:unmobile/core/error/failures.dart';
import 'package:unmobile/features/auth/domain/entities/user.dart';
import 'package:unmobile/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  Future<Either<Failure, User?>> call() async {
    return await repository.getCurrentUser();
  }
}
