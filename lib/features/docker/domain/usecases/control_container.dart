import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:unmobile/core/error/failures.dart';
import 'package:unmobile/core/usecases/usecase.dart';
import 'package:unmobile/features/docker/domain/repositories/docker_repository.dart';

/// Use case for controlling Docker containers (start/stop/restart/etc.)
class ControlContainer implements UseCase<void, ControlContainerParams> {
  const ControlContainer(this._repository);

  final DockerRepository _repository;

  @override
  Future<Either<Failure, void>> call(ControlContainerParams params) async {
    switch (params.action) {
      case ContainerAction.start:
        return _repository.startContainer(params.containerId);
      case ContainerAction.stop:
        return _repository.stopContainer(params.containerId);
      case ContainerAction.restart:
        return _repository.restartContainer(params.containerId);
      case ContainerAction.pause:
        return _repository.pauseContainer(params.containerId);
      case ContainerAction.unpause:
        return _repository.unpauseContainer(params.containerId);
      case ContainerAction.remove:
        return _repository.removeContainer(
          params.containerId,
          force: params.force,
        );
    }
  }
}

class ControlContainerParams extends Equatable {
  const ControlContainerParams({
    required this.containerId,
    required this.action,
    this.force = false,
  });

  final String containerId;
  final ContainerAction action;
  final bool force;

  @override
  List<Object?> get props => [containerId, action, force];
}

enum ContainerAction {
  start,
  stop,
  restart,
  pause,
  unpause,
  remove,
}
