import 'package:dartz/dartz.dart';
import 'package:unmobile/core/error/failures.dart';
import 'package:unmobile/features/server/domain/entities/disk_info.dart';
import 'package:unmobile/features/server/domain/entities/parity_info.dart';
import 'package:unmobile/features/server/domain/entities/server_info.dart';

/// Repository interface for server operations
abstract class ServerRepository {
  /// Get server information
  Future<Either<Failure, ServerInfo>> getServerInfo();

  /// Get disk information
  Future<Either<Failure, List<DiskInfo>>> getDisks();

  /// Get parity information
  Future<Either<Failure, ParityInfo>> getParityInfo();

  /// Shutdown server
  Future<Either<Failure, void>> shutdown();

  /// Reboot server
  Future<Either<Failure, void>> reboot();

  /// Start array
  Future<Either<Failure, void>> startArray();

  /// Stop array
  Future<Either<Failure, void>> stopArray();
}
