import 'package:dartz/dartz.dart';
import 'package:unmobile/core/error/failures.dart';
import 'package:unmobile/core/usecases/usecase.dart';
import 'package:unmobile/features/server/domain/entities/server_info.dart';
import 'package:unmobile/features/server/domain/repositories/server_repository.dart';

/// Use case for getting server information
class GetServerInfo implements UseCase<ServerInfo, NoParams> {
  const GetServerInfo(this._repository);

  final ServerRepository _repository;

  @override
  Future<Either<Failure, ServerInfo>> call(NoParams params) async {
    return _repository.getServerInfo();
  }
}
