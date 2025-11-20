import 'package:equatable/equatable.dart';

/// Docker container statistics entity
class ContainerStats extends Equatable {
  const ContainerStats({
    required this.containerId,
    required this.cpuUsage,
    required this.memoryUsage,
    required this.memoryLimit,
    required this.networkRx,
    required this.networkTx,
    required this.blockRead,
    required this.blockWrite,
    required this.timestamp,
  });

  final String containerId;
  final double cpuUsage;
  final int memoryUsage;
  final int memoryLimit;
  final int networkRx;
  final int networkTx;
  final int blockRead;
  final int blockWrite;
  final DateTime timestamp;

  double get memoryUsagePercentage =>
      memoryLimit > 0 ? (memoryUsage / memoryLimit) * 100 : 0;

  @override
  List<Object?> get props => [
        containerId,
        cpuUsage,
        memoryUsage,
        memoryLimit,
        networkRx,
        networkTx,
        blockRead,
        blockWrite,
        timestamp,
      ];
}
