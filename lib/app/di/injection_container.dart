import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/database/app_database.dart';
import '../../core/database/daos/card_dao.dart';
import '../../core/database/daos/session_dao.dart';
import '../../features/settings/domain/entities/deep_work_settings.dart';
import '../../features/settings/domain/entities/pomodoro_settings.dart';
import 'injection_container.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

/// Manual registrations for types not covered by injectable code-gen
/// (e.g., third-party classes without @injectable annotation).
@module
abstract class AppModule {
  @lazySingleton
  AppDatabase get database => AppDatabase();

  @lazySingleton
  CardDao cardDao(AppDatabase db) => db.cardDao;

  @lazySingleton
  SessionDao sessionDao(AppDatabase db) => db.sessionDao;

  @preResolve
  @lazySingleton
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  /// Default Pomodoro settings — Sprint 5 will read these from prefs.
  @lazySingleton
  PomodoroSettings get pomodoroSettings => const PomodoroSettings();

  /// Default Deep Work settings — Sprint 5 will read these from prefs.
  @lazySingleton
  DeepWorkSettings get deepWorkSettings => const DeepWorkSettings();
}
