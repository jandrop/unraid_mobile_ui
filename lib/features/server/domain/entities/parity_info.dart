import 'package:equatable/equatable.dart';

/// Parity information entity
class ParityInfo extends Equatable {
  const ParityInfo({
    required this.status,
    required this.syncProgress,
    required this.syncSpeed,
    required this.estimatedFinish,
    required this.errorCount,
    required this.lastCheckDate,
  });

  final ParityStatus status;
  final double syncProgress;
  final String syncSpeed;
  final DateTime? estimatedFinish;
  final int errorCount;
  final DateTime? lastCheckDate;

  bool get isHealthy => status == ParityStatus.valid && errorCount == 0;

  bool get isSyncing =>
      status == ParityStatus.syncing ||
      status == ParityStatus.checking ||
      status == ParityStatus.rebuilding;

  @override
  List<Object?> get props => [
        status,
        syncProgress,
        syncSpeed,
        estimatedFinish,
        errorCount,
        lastCheckDate,
      ];
}

enum ParityStatus {
  valid,
  invalid,
  syncing,
  checking,
  rebuilding,
  disabled,
  unknown,
}
