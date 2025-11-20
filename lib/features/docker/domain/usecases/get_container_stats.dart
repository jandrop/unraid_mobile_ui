import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:unmobile/core/error/failures.dart';
import 'package:unmobile/core/usecases/usecase.dart';
import 'package:unmobile/features/docker/domain/entities/container_stats.dart';
import 'package:unmobile/features/docker/domain/repositories/docker_repository.dart';

/// Use case for getting container statistics
class GetContainerStats
    implements UseCase<ContainerStats, GetContainerStatsParams> {
  const GetContainerStats(this._repository);

  final DockerRepository _repository;

  @override
  Future<Either<Failure, ContainerStats>> call(
    GetContainerStatsParams params,
  ) async {
    return _repository.getContainerStats(params.containerId);
  }
}

class GetContainerStatsParams extends Equatable {
  const GetContainerStatsParams({required this.containerId});

  final String containerId;

  @override
  List<Object?> get props => [containerId];
}
