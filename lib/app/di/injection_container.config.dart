// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:strange/app/di/injection_container.dart' as _i468;
import 'package:strange/core/database/app_database.dart' as _i438;
import 'package:strange/core/database/daos/card_dao.dart' as _i913;
import 'package:strange/core/database/daos/session_dao.dart' as _i905;
import 'package:strange/features/home/data/repositories/card_repository_impl.dart'
    as _i707;
import 'package:strange/features/home/domain/repositories/card_repository.dart'
    as _i277;
import 'package:strange/features/home/domain/usecases/archive_card_usecase.dart'
    as _i474;
import 'package:strange/features/home/domain/usecases/create_card_usecase.dart'
    as _i913;
import 'package:strange/features/home/domain/usecases/delete_card_usecase.dart'
    as _i1066;
import 'package:strange/features/home/domain/usecases/get_card_by_id_usecase.dart'
    as _i494;
import 'package:strange/features/home/domain/usecases/reorder_cards_usecase.dart'
    as _i1035;
import 'package:strange/features/home/domain/usecases/restore_card_usecase.dart'
    as _i427;
import 'package:strange/features/home/domain/usecases/update_card_usecase.dart'
    as _i319;
import 'package:strange/features/home/domain/usecases/watch_cards_by_type_usecase.dart'
    as _i33;
import 'package:strange/features/home/presentation/cubit/card_form_cubit.dart'
    as _i176;
import 'package:strange/features/home/presentation/cubit/home_cubit.dart'
    as _i663;
import 'package:strange/features/settings/domain/entities/deep_work_settings.dart'
    as _i58;
import 'package:strange/features/settings/domain/entities/pomodoro_settings.dart'
    as _i651;
import 'package:strange/features/stats/data/datasources/stats_local_datasource.dart'
    as _i873;
import 'package:strange/features/stats/data/repositories/stats_repository_impl.dart'
    as _i65;
import 'package:strange/features/stats/domain/repositories/stats_repository.dart'
    as _i662;
import 'package:strange/features/stats/domain/usecases/get_column_data_usecase.dart'
    as _i53;
import 'package:strange/features/stats/domain/usecases/get_heatmap_data_usecase.dart'
    as _i1039;
import 'package:strange/features/stats/domain/usecases/get_pie_data_usecase.dart'
    as _i650;
import 'package:strange/features/stats/presentation/cubit/stats_cubit.dart'
    as _i97;
import 'package:strange/features/working/data/datasources/timer_preferences.dart'
    as _i806;
import 'package:strange/features/working/data/datasources/timer_service.dart'
    as _i911;
import 'package:strange/features/working/data/repositories/session_repository_impl.dart'
    as _i61;
import 'package:strange/features/working/domain/repositories/session_repository.dart'
    as _i32;
import 'package:strange/features/working/domain/usecases/save_session_usecase.dart'
    as _i316;
import 'package:strange/features/working/presentation/cubit/deep_work_cubit.dart'
    as _i1015;
import 'package:strange/features/working/presentation/cubit/pomodoro_cubit.dart'
    as _i678;
import 'package:strange/features/working/presentation/cubit/working_cubit.dart'
    as _i435;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.lazySingleton<_i438.AppDatabase>(() => appModule.database);
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i651.PomodoroSettings>(() => appModule.pomodoroSettings);
    gh.lazySingleton<_i58.DeepWorkSettings>(() => appModule.deepWorkSettings);
    gh.lazySingleton<_i806.TimerPreferences>(
        () => _i806.TimerPreferences(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i911.TimerService>(
      () => _i911.TimerService(gh<_i806.TimerPreferences>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i913.CardDao>(
        () => appModule.cardDao(gh<_i438.AppDatabase>()));
    gh.lazySingleton<_i905.SessionDao>(
        () => appModule.sessionDao(gh<_i438.AppDatabase>()));
    gh.lazySingleton<_i873.StatsLocalDatasource>(
        () => _i873.StatsLocalDatasource(
              gh<_i905.SessionDao>(),
              gh<_i913.CardDao>(),
            ));
    gh.lazySingleton<_i662.StatsRepository>(
        () => _i65.StatsRepositoryImpl(gh<_i873.StatsLocalDatasource>()));
    gh.lazySingleton<_i32.SessionRepository>(
        () => _i61.SessionRepositoryImpl(gh<_i905.SessionDao>()));
    gh.lazySingleton<_i277.CardRepository>(() => _i707.CardRepositoryImpl(
          gh<_i913.CardDao>(),
          gh<_i905.SessionDao>(),
        ));
    gh.factory<_i53.GetColumnDataUsecase>(
        () => _i53.GetColumnDataUsecase(gh<_i662.StatsRepository>()));
    gh.factory<_i1039.GetHeatmapDataUsecase>(
        () => _i1039.GetHeatmapDataUsecase(gh<_i662.StatsRepository>()));
    gh.factory<_i650.GetPieDataUsecase>(
        () => _i650.GetPieDataUsecase(gh<_i662.StatsRepository>()));
    gh.lazySingleton<_i316.SaveSessionUseCase>(
        () => _i316.SaveSessionUseCase(gh<_i32.SessionRepository>()));
    gh.lazySingleton<_i474.ArchiveCardUseCase>(
        () => _i474.ArchiveCardUseCase(gh<_i277.CardRepository>()));
    gh.lazySingleton<_i913.CreateCardUseCase>(
        () => _i913.CreateCardUseCase(gh<_i277.CardRepository>()));
    gh.lazySingleton<_i1066.DeleteCardUseCase>(
        () => _i1066.DeleteCardUseCase(gh<_i277.CardRepository>()));
    gh.lazySingleton<_i494.GetCardByIdUseCase>(
        () => _i494.GetCardByIdUseCase(gh<_i277.CardRepository>()));
    gh.lazySingleton<_i1035.ReorderCardsUseCase>(
        () => _i1035.ReorderCardsUseCase(gh<_i277.CardRepository>()));
    gh.lazySingleton<_i427.RestoreCardUseCase>(
        () => _i427.RestoreCardUseCase(gh<_i277.CardRepository>()));
    gh.lazySingleton<_i319.UpdateCardUseCase>(
        () => _i319.UpdateCardUseCase(gh<_i277.CardRepository>()));
    gh.lazySingleton<_i33.WatchCardsByTypeUseCase>(
        () => _i33.WatchCardsByTypeUseCase(gh<_i277.CardRepository>()));
    gh.factory<_i176.CardFormCubit>(() => _i176.CardFormCubit(
          gh<_i913.CreateCardUseCase>(),
          gh<_i319.UpdateCardUseCase>(),
          gh<_i494.GetCardByIdUseCase>(),
        ));
    gh.factory<_i97.StatsCubit>(() => _i97.StatsCubit(
          gh<_i1039.GetHeatmapDataUsecase>(),
          gh<_i53.GetColumnDataUsecase>(),
          gh<_i650.GetPieDataUsecase>(),
        ));
    gh.factory<_i663.HomeCubit>(() => _i663.HomeCubit(
          gh<_i33.WatchCardsByTypeUseCase>(),
          gh<_i913.CreateCardUseCase>(),
          gh<_i319.UpdateCardUseCase>(),
          gh<_i1066.DeleteCardUseCase>(),
          gh<_i474.ArchiveCardUseCase>(),
          gh<_i427.RestoreCardUseCase>(),
          gh<_i1035.ReorderCardsUseCase>(),
        ));
    gh.factory<_i435.WorkingCubit>(
        () => _i435.WorkingCubit(gh<_i494.GetCardByIdUseCase>()));
    gh.factory<_i1015.DeepWorkCubit>(() => _i1015.DeepWorkCubit(
          gh<_i911.TimerService>(),
          gh<_i806.TimerPreferences>(),
          gh<_i316.SaveSessionUseCase>(),
        ));
    gh.factory<_i678.PomodoroCubit>(() => _i678.PomodoroCubit(
          gh<_i911.TimerService>(),
          gh<_i806.TimerPreferences>(),
          gh<_i316.SaveSessionUseCase>(),
        ));
    return this;
  }
}

class _$AppModule extends _i468.AppModule {}
