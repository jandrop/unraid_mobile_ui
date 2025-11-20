import 'package:equatable/equatable.dart';

/// Docker container entity
class DockerContainer extends Equatable {
  const DockerContainer({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.state,
    required this.created,
    this.ports = const [],
    this.networks = const [],
    this.cpuUsage = 0.0,
    this.memoryUsage = 0,
    this.memoryLimit = 0,
    this.networkRx = 0,
    this.networkTx = 0,
  });

  final String id;
  final String name;
  final String image;
  final String status;
  final ContainerState state;
  final DateTime created;
  final List<PortMapping> ports;
  final List<String> networks;
  final double cpuUsage;
  final int memoryUsage;
  final int memoryLimit;
  final int networkRx;
  final int networkTx;

  bool get isRunning => state == ContainerState.running;

  double get memoryUsagePercentage =>
      memoryLimit > 0 ? (memoryUsage / memoryLimit) * 100 : 0;

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        status,
        state,
        created,
        ports,
        networks,
        cpuUsage,
        memoryUsage,
        memoryLimit,
        networkRx,
        networkTx,
      ];
}

enum ContainerState {
  created,
  running,
  paused,
  restarting,
  removing,
  exited,
  dead,
}

class PortMapping extends Equatable {
  const PortMapping({
    required this.privatePort,
    this.publicPort,
    required this.type,
  });

  final int privatePort;
  final int? publicPort;
  final String type;

  @override
  List<Object?> get props => [privatePort, publicPort, type];
}
