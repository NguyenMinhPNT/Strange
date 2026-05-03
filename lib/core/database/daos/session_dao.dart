import 'package:drift/drift.dart';

import '../app_database.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [Sessions])
class SessionDao extends DatabaseAccessor<AppDatabase> with _$SessionDaoMixin {
  SessionDao(super.db);

  Future<int> insertSession(SessionsCompanion companion) =>
      into(sessions).insert(companion);

  Future<List<SessionData>> getSessionsForCard(int cardId) =>
      (select(sessions)
            ..where((s) => s.cardId.equals(cardId))
            ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
          .get();

  Future<List<SessionData>> getSessionsInRange(DateTime start, DateTime end) =>
      (select(sessions)
            ..where(
              (s) =>
                  s.startedAt.isBiggerOrEqualValue(start) &
                  s.startedAt.isSmallerOrEqualValue(end),
            )
            ..orderBy([(s) => OrderingTerm.asc(s.startedAt)]))
          .get();

  Future<int> deleteSessionById(int id) =>
      (delete(sessions)..where((s) => s.id.equals(id))).go();

  /// Delete all sessions for a card (cascade on card delete).
  Future<int> deleteSessionsForCard(int cardId) =>
      (delete(sessions)..where((s) => s.cardId.equals(cardId))).go();
}
