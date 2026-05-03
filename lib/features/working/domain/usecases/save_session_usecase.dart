import 'package:injectable/injectable.dart';

import '../entities/enums/session_status.dart';
import '../entities/enums/timer_type.dart';
import '../entities/session.dart';
import '../repositories/session_repository.dart';

class SaveSessionParams {
  const SaveSessionParams({
    required this.cardId,
    required this.timerType,
    required this.status,
    required this.startedAt,
    required this.endedAt,
    required this.totalWorkSeconds,
    this.totalBreakSeconds = 0,
    this.pomodoroRoundsCompleted = 0,
    this.deepWorkPauseSeconds = 0,
  });

  final int cardId;
  final TimerType timerType;
  final SessionStatus status;
  final DateTime startedAt;
  final DateTime endedAt;
  final int totalWorkSeconds;
  final int totalBreakSeconds;
  final int pomodoroRoundsCompleted;
  final int deepWorkPauseSeconds;
}

@lazySingleton
class SaveSessionUseCase {
  const SaveSessionUseCase(this._repository);

  final SessionRepository _repository;

  Future<Session> call(SaveSessionParams params) => _repository.saveSession(
        cardId: params.cardId,
        timerType: params.timerType,
        status: params.status,
        startedAt: params.startedAt,
        endedAt: params.endedAt,
        totalWorkSeconds: params.totalWorkSeconds,
        totalBreakSeconds: params.totalBreakSeconds,
        pomodoroRoundsCompleted: params.pomodoroRoundsCompleted,
        deepWorkPauseSeconds: params.deepWorkPauseSeconds,
      );
}
