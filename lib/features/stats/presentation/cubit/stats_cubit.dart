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
    StatsRange range = StatsRange.oneMonth,
    int? cardId,
    DateTime? oneMonthReference,
  ]) async {
    emit(const StatsLoading());
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      late final DateTime start;
      late final DateTime end;
      if (range == StatsRange.oneMonth) {
        final fallbackReference = state is StatsLoaded &&
                (state as StatsLoaded).range == StatsRange.oneMonth
            ? (state as StatsLoaded).periodStart
            : today;
        final reference = oneMonthReference ?? fallbackReference;
        final monthStart = DateTime(reference.year, reference.month, 1);
        final monthEnd = DateTime(
          reference.year,
          reference.month + 1,
          0,
          23,
          59,
          59,
        );
        final currentMonthStart = DateTime(today.year, today.month, 1);
        final isCurrentMonth = monthStart.year == currentMonthStart.year &&
            monthStart.month == currentMonthStart.month;
        start = monthStart;
        end = isCurrentMonth
            ? DateTime(today.year, today.month, today.day, 23, 59, 59)
            : monthEnd;
      } else {
        start = range.startDate;
        end = DateTime(today.year, today.month, today.day, 23, 59, 59);
      }

      final cards = await _repository.getAllCards();
      final heatmap = await _getHeatmapData(start, end, cardId);
      final columns = await _getColumnData(start, end, cardId);
      final pieSlices = await _getPieData(start, end, cardId);

      final totalSeconds = pieSlices.fold(0, (s, p) => s + p.totalSeconds);

      emit(
        StatsLoaded(
          heatmap: heatmap,
          columns: columns,
          pieSlices: pieSlices,
          range: range,
          periodStart: start,
          periodEnd: end,
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
    final oneMonthReference = range == StatsRange.oneMonth
        ? DateTime.now()
        : null;
    return loadStats(range, selectedCardId, oneMonthReference);
  }

  Future<void> changeCardFilter(int? cardId) {
    final currentRange = state is StatsLoaded
        ? (state as StatsLoaded).range
        : StatsRange.oneMonth;
    final oneMonthReference =
        state is StatsLoaded && currentRange == StatsRange.oneMonth
            ? (state as StatsLoaded).periodStart
            : null;
    return loadStats(currentRange, cardId, oneMonthReference);
  }

  Future<void> showPreviousOneMonth() {
    final current = state;
    if (current is! StatsLoaded || current.range != StatsRange.oneMonth) {
      return Future.value();
    }
    final previousMonth =
        DateTime(current.periodStart.year, current.periodStart.month - 1, 1);
    return loadStats(
        StatsRange.oneMonth, current.selectedCardId, previousMonth);
  }

  Future<void> showNextOneMonth() {
    final current = state;
    if (current is! StatsLoaded || current.range != StatsRange.oneMonth) {
      return Future.value();
    }
    final nextMonth =
        DateTime(current.periodStart.year, current.periodStart.month + 1, 1);
    final now = DateTime.now();
    final currentMonthStart = DateTime(now.year, now.month, 1);
    if (nextMonth.isAfter(currentMonthStart)) {
      return Future.value();
    }
    return loadStats(StatsRange.oneMonth, current.selectedCardId, nextMonth);
  }
}
