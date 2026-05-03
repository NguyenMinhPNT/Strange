import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/session_dao.dart';
import '../../domain/entities/enums/session_status.dart';
import '../../domain/entities/enums/timer_type.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';

@LazySingleton(as: SessionRepository)
class SessionRepositoryImpl implements SessionRepository {
  const SessionRepositoryImpl(this._sessionDao);

  final SessionDao _sessionDao;

  @override
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
  }) async {
    final now = DateTime.now();
    final id = await _sessionDao.insertSession(
      SessionsCompanion.insert(
        cardId: cardId,
        timerType: timerType.value,
        status: Value(status.value),
        startedAt: startedAt,
        endedAt: endedAt,
        totalWorkSeconds: Value(totalWorkSeconds),
        totalBreakSeconds: Value(totalBreakSeconds),
        pomodoroRoundsCompleted: Value(pomodoroRoundsCompleted),
        deepWorkPauseSeconds: Value(deepWorkPauseSeconds),
        createdAt: now,
      ),
    );
    return Session(
      id: id,
      cardId: cardId,
      timerType: timerType,
      status: status,
      startedAt: startedAt,
      endedAt: endedAt,
      totalWorkSeconds: totalWorkSeconds,
      totalBreakSeconds: totalBreakSeconds,
      pomodoroRoundsCompleted: pomodoroRoundsCompleted,
      deepWorkPauseSeconds: deepWorkPauseSeconds,
    );
  }

  @override
  Future<List<Session>> getSessionsForCard(int cardId) async {
    final rows = await _sessionDao.getSessionsForCard(cardId);
    return rows
        .map(
          (r) => Session(
            id: r.id,
            cardId: r.cardId,
            timerType: TimerType.fromString(r.timerType),
            status: SessionStatus.fromString(r.status),
            startedAt: r.startedAt,
            endedAt: r.endedAt,
            totalWorkSeconds: r.totalWorkSeconds,
            totalBreakSeconds: r.totalBreakSeconds,
            pomodoroRoundsCompleted: r.pomodoroRoundsCompleted,
            deepWorkPauseSeconds: r.deepWorkPauseSeconds,
          ),
        )
        .toList();
  }
}
