import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:unmobile/core/error/failures.dart';
import 'package:unmobile/features/auth/domain/entities/user.dart';
import 'package:unmobile/features/auth/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(
      username: params.username,
      password: params.password,
      serverUrl: params.serverUrl,
    );
  }
}

class LoginParams extends Equatable {
  final String username;
  final String password;
  final String serverUrl;

  const LoginParams({
    required this.username,
    required this.password,
    required this.serverUrl,
  });

  @override
  List<Object> get props => [username, password, serverUrl];
}
