import '../entities/session.dart';
import '../entities/enums/session_status.dart';
import '../entities/enums/timer_type.dart';

abstract class SessionRepository {
  Future<Session> saveSession({
    required int cardId,
    required TimerType timerType,
    required SessionStatus status,
    required DateTime startedAt,
    required DateTime endedAt,
    required int totalWorkSeconds,
    required int totalBreakSeconds,
    required int pomodoroRoundsCompleted,
    required int deepWorkPauseSeconds,
  });

  Future<List<Session>> getSessionsForCard(int cardId);
}
