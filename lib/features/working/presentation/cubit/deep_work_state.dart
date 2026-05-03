import '../../domain/entities/session.dart';

sealed class DeepWorkState {}

final class DeepWorkInitial extends DeepWorkState {}

final class DeepWorkRunning extends DeepWorkState {
  DeepWorkRunning({
    required this.elapsedWorkSeconds,
    required this.totalPauseSeconds,
  });

  final int elapsedWorkSeconds;
  final int totalPauseSeconds;
}

final class DeepWorkPaused extends DeepWorkState {
  DeepWorkPaused({
    required this.elapsedWorkSeconds,
    required this.totalPauseSeconds,
    required this.pauseElapsedSeconds,
    required this.maxPauseSeconds,
    required this.remainingPauseSeconds,
  });

  final int elapsedWorkSeconds;
  final int totalPauseSeconds;
  final int pauseElapsedSeconds;
  final int maxPauseSeconds;
  final int remainingPauseSeconds;
}

final class DeepWorkAutoEnded extends DeepWorkState {
  DeepWorkAutoEnded({
    required this.totalWorkSeconds,
    required this.savedSession,
  });

  final int totalWorkSeconds;
  final Session savedSession;
}

final class DeepWorkEnded extends DeepWorkState {
  DeepWorkEnded({
    required this.totalWorkSeconds,
    required this.totalPauseSeconds,
    required this.savedSession,
  });

  final int totalWorkSeconds;
  final int totalPauseSeconds;
  final Session savedSession;
}

final class DeepWorkError extends DeepWorkState {
  DeepWorkError(this.message);
  final String message;
}
