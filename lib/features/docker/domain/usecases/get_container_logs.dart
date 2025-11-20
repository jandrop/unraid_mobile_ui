import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:unmobile/core/error/failures.dart';
import 'package:unmobile/core/usecases/usecase.dart';
import 'package:unmobile/features/docker/domain/repositories/docker_repository.dart';

/// Use case for getting container logs
class GetContainerLogs implements UseCase<String, GetContainerLogsParams> {
  const GetContainerLogs(this._repository);

  final DockerRepository _repository;

  @override
  Future<Either<Failure, String>> call(GetContainerLogsParams params) async {
    return _repository.getContainerLogs(params.containerId, tail: params.tail);
  }
}

class GetContainerLogsParams extends Equatable {
  const GetContainerLogsParams({
    required this.containerId,
    this.tail = 100,
  });

  final String containerId;
  final int tail;

  @override
  List<Object?> get props => [containerId, tail];
}
