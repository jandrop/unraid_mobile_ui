import 'package:dartz/dartz.dart';
import 'package:unmobile/core/error/failures.dart';
import 'package:unmobile/features/docker/domain/entities/container_stats.dart';
import 'package:unmobile/features/docker/domain/entities/docker_container.dart';

/// Repository interface for Docker operations
abstract class DockerRepository {
  /// Get all Docker containers
  Future<Either<Failure, List<DockerContainer>>> getContainers({
    bool all = false,
  });

  /// Get a specific container by ID
  Future<Either<Failure, DockerContainer>> getContainer(String id);

  /// Get container statistics
  Future<Either<Failure, ContainerStats>> getContainerStats(String id);

  /// Start a container
  Future<Either<Failure, void>> startContainer(String id);

  /// Stop a container
  Future<Either<Failure, void>> stopContainer(String id);

  /// Restart a container
  Future<Either<Failure, void>> restartContainer(String id);

  /// Pause a container
  Future<Either<Failure, void>> pauseContainer(String id);

  /// Unpause a container
  Future<Either<Failure, void>> unpauseContainer(String id);

  /// Remove a container
  Future<Either<Failure, void>> removeContainer(String id,
      {bool force = false});

  /// Get container logs
  Future<Either<Failure, String>> getContainerLogs(String id, {int tail = 100});
}
