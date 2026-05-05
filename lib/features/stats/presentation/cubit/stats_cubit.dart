import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/enums/stats_range.dart';
import '../../domain/repositories/stats_repository.dart';
import '../../domain/usecases/get_column_data_usecase.dart';
import '../../domain/usecases/get_heatmap_data_usecase.dart';
import '../../domain/usecases/get_pie_data_usecase.dart';
import 'stats_state.dart';

@injectable
class StatsCubit extends Cubit<StatsState> {
  StatsCubit(
    this._getHeatmapData,
    this._getColumnData,
    this._getPieData,
    this._repository,
  ) : super(const StatsInitial());

  final GetHeatmapDataUsecase _getHeatmapData;
  final GetColumnDataUsecase _getColumnData;
  final GetPieDataUsecase _getPieData;
  final StatsRepository _repository;

  Future<void> loadStats([
    StatsRange range = StatsRange.sevenDays,
    int? cardId,
  ]) async {
    emit(const StatsLoading());
    try {
      final now = DateTime.now();
      final endDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
      final start = range.startDate;

      final cards = await _repository.getAllCards();
      final heatmap = await _getHeatmapData(start, endDay, cardId);
      final columns = await _getColumnData(start, endDay, cardId);
      final pieSlices = await _getPieData(start, endDay, cardId);

      final totalSeconds = pieSlices.fold(0, (s, p) => s + p.totalSeconds);

      emit(
        StatsLoaded(
          heatmap: heatmap,
          columns: columns,
          pieSlices: pieSlices,
          range: range,
          totalWorkSeconds: totalSeconds,
          cards: cards,
          selectedCardId: cardId,
        ),
      );
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }

  Future<void> changeRange(StatsRange range) {
    final selectedCardId =
        state is StatsLoaded ? (state as StatsLoaded).selectedCardId : null;
    return loadStats(range, selectedCardId);
  }

  Future<void> changeCardFilter(int? cardId) {
    final currentRange = state is StatsLoaded
        ? (state as StatsLoaded).range
        : StatsRange.sevenDays;
    return loadStats(currentRange, cardId);
  }
}
