import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:unmobile/core/error/failures.dart';
import 'package:unmobile/core/usecases/usecase.dart';
import 'package:unmobile/features/server/domain/repositories/server_repository.dart';

/// Use case for controlling array (start/stop)
class ControlArray implements UseCase<void, ControlArrayParams> {
  const ControlArray(this._repository);

  final ServerRepository _repository;

  @override
  Future<Either<Failure, void>> call(ControlArrayParams params) async {
    if (params.action == ArrayAction.start) {
      return _repository.startArray();
    } else {
      return _repository.stopArray();
    }
  }
}

class ControlArrayParams extends Equatable {
  const ControlArrayParams({required this.action});

  final ArrayAction action;

  @override
  List<Object?> get props => [action];
}

enum ArrayAction {
  start,
  stop,
}
