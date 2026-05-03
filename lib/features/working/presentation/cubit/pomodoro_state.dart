import '../../domain/entities/enums/pomodoro_phase.dart';
import '../../domain/entities/session.dart';

sealed class PomodoroState {}

final class PomodoroInitial extends PomodoroState {}

final class PomodoroRunning extends PomodoroState {
  PomodoroRunning({
    required this.phase,
    required this.round,
    required this.elapsedSeconds,
    required this.remainingSeconds,
    required this.progress,
    required this.completedRounds,
    required this.shortBreakInterval,
  });

  final PomodoroPhase phase;
  final int round;
  final int elapsedSeconds;
  final int remainingSeconds;
  final double progress;
  final int completedRounds;
  final int shortBreakInterval;
}

final class PomodoroPaused extends PomodoroState {
  PomodoroPaused({
    required this.phase,
    required this.round,
    required this.remainingSeconds,
    required this.progress,
    required this.completedRounds,
    required this.shortBreakInterval,
  });

  final PomodoroPhase phase;
  final int round;
  final int remainingSeconds;
  final double progress;
  final int completedRounds;
  final int shortBreakInterval;
}

final class PomodoroPhaseComplete extends PomodoroState {
  PomodoroPhaseComplete({
    required this.completedRounds,
    required this.nextPhase,
  });

  final int completedRounds;
  final PomodoroPhase nextPhase;
}

final class PomodoroEnded extends PomodoroState {
  PomodoroEnded({
    required this.totalWorkSeconds,
    required this.roundsCompleted,
    required this.savedSession,
  });

  final int totalWorkSeconds;
  final int roundsCompleted;
  final Session savedSession;
}

final class PomodoroError extends PomodoroState {
  PomodoroError(this.message);
  final String message;
}
