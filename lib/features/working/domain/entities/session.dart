import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums/session_status.dart';
import 'enums/timer_type.dart';

part 'session.freezed.dart';

@freezed
class Session with _$Session {
  const factory Session({
    required int id,
    required int cardId,
    required TimerType timerType,
    required SessionStatus status,
    required DateTime startedAt,
    required DateTime endedAt,
    required int totalWorkSeconds,
    required int totalBreakSeconds,
    required int pomodoroRoundsCompleted,
    required int deepWorkPauseSeconds,
  }) = _Session;
}
