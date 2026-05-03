import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/card_dao.dart';
import 'daos/session_dao.dart';

part 'app_database.g.dart';

@DataClassName('CardData')
class Cards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(max: 40)();
  TextColumn get colorHex => text().withDefault(const Constant('#D52B1E'))();
  TextColumn get type => text()(); // learning | project | habit
  IntColumn get position => integer().withDefault(const Constant(0))();
  TextColumn get status =>
      text().withDefault(const Constant('active'))(); // active | archived
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('SessionData')
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId => integer().references(Cards, #id)();
  TextColumn get timerType => text()(); // pomodoro | deep_work
  TextColumn get status => text().withDefault(
    const Constant('completed'),
  )(); // completed | abandoned
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();
  IntColumn get totalWorkSeconds => integer().withDefault(const Constant(0))();
  IntColumn get totalBreakSeconds => integer().withDefault(const Constant(0))();
  IntColumn get pomodoroRoundsCompleted =>
      integer().withDefault(const Constant(0))();
  IntColumn get deepWorkPauseSeconds =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [Cards, Sessions], daos: [CardDao, SessionDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_cards_type_status_position '
        'ON cards (type, status, position)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_sessions_card_date '
        'ON sessions (card_id, started_at)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_sessions_date '
        'ON sessions (started_at)',
      );
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'strange_db');
  }
}
