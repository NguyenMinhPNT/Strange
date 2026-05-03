import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums/pomodoro_phase.dart';

part 'pomodoro_session.freezed.dart';

@freezed
class PomodoroSession with _$PomodoroSession {
  const factory PomodoroSession({
    required int cardId,
    required PomodoroPhase currentPhase,
    required int currentRound,
    required int targetWorkSeconds,
    required int targetShortBreakSeconds,
    required int targetLongBreakSeconds,
    required int shortBreakInterval,
    required int elapsedSeconds,
    required int completedRounds,
    required DateTime startedAt,
  }) = _PomodoroSession;
}
