import 'package:dartz/dartz.dart';
import 'package:unmobile/core/error/failures.dart';
import 'package:unmobile/core/usecases/usecase.dart';
import 'package:unmobile/features/server/domain/entities/disk_info.dart';
import 'package:unmobile/features/server/domain/repositories/server_repository.dart';

/// Use case for getting disk information
class GetDisks implements UseCase<List<DiskInfo>, NoParams> {
  const GetDisks(this._repository);

  final ServerRepository _repository;

  @override
  Future<Either<Failure, List<DiskInfo>>> call(NoParams params) async {
    return _repository.getDisks();
  }
}
