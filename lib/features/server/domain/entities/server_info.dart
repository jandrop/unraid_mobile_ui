import 'package:equatable/equatable.dart';

/// Server information entity
class ServerInfo extends Equatable {
  const ServerInfo({
    required this.hostname,
    required this.version,
    required this.uptime,
    required this.cpuModel,
    required this.cpuCores,
    required this.totalMemory,
    required this.availableMemory,
    required this.arrayStatus,
  });

  final String hostname;
  final String version;
  final Duration uptime;
  final String cpuModel;
  final int cpuCores;
  final int totalMemory;
  final int availableMemory;
  final String arrayStatus;

  double get memoryUsagePercentage =>
      ((totalMemory - availableMemory) / totalMemory) * 100;

  @override
  List<Object?> get props => [
        hostname,
        version,
        uptime,
        cpuModel,
        cpuCores,
        totalMemory,
        availableMemory,
        arrayStatus,
      ];
}
