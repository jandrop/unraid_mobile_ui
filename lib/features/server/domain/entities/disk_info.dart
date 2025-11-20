import 'package:equatable/equatable.dart';

/// Disk information entity
class DiskInfo extends Equatable {
  const DiskInfo({
    required this.name,
    required this.device,
    required this.size,
    required this.used,
    required this.free,
    required this.temperature,
    required this.status,
    this.errorCount = 0,
  });

  final String name;
  final String device;
  final int size;
  final int used;
  final int free;
  final int temperature;
  final DiskStatus status;
  final int errorCount;

  double get usagePercentage => (used / size) * 100;

  bool get isHealthy =>
      status == DiskStatus.active && temperature < 50 && errorCount == 0;

  @override
  List<Object?> get props => [
        name,
        device,
        size,
        used,
        free,
        temperature,
        status,
        errorCount,
      ];
}

enum DiskStatus {
  active,
  standby,
  error,
  disabled,
  unknown,
}
