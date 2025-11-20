import 'package:dartz/dartz.dart';
import 'package:unmobile/core/error/failures.dart';
import 'package:unmobile/core/usecases/usecase.dart';
import 'package:unmobile/features/server/domain/entities/parity_info.dart';
import 'package:unmobile/features/server/domain/repositories/server_repository.dart';

/// Use case for getting parity information
class GetParityInfo implements UseCase<ParityInfo, NoParams> {
  const GetParityInfo(this._repository);

  final ServerRepository _repository;

  @override
  Future<Either<Failure, ParityInfo>> call(NoParams params) async {
    return _repository.getParityInfo();
  }
}
