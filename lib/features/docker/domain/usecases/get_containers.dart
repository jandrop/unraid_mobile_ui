import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:unmobile/core/error/failures.dart';
import 'package:unmobile/core/usecases/usecase.dart';
import 'package:unmobile/features/docker/domain/entities/docker_container.dart';
import 'package:unmobile/features/docker/domain/repositories/docker_repository.dart';

/// Use case for getting Docker containers
class GetContainers
    implements UseCase<List<DockerContainer>, GetContainersParams> {
  const GetContainers(this._repository);

  final DockerRepository _repository;

  @override
  Future<Either<Failure, List<DockerContainer>>> call(
    GetContainersParams params,
  ) async {
    return _repository.getContainers(all: params.includeAll);
  }
}

class GetContainersParams extends Equatable {
  const GetContainersParams({this.includeAll = false});

  final bool includeAll;

  @override
  List<Object?> get props => [includeAll];
}
