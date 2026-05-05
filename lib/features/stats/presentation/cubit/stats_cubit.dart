import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/enums/stats_range.dart';
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
  ) : super(const StatsInitial());

  final GetHeatmapDataUsecase _getHeatmapData;
  final GetColumnDataUsecase _getColumnData;
  final GetPieDataUsecase _getPieData;

  Future<void> loadStats([StatsRange range = StatsRange.sevenDays]) async {
    emit(const StatsLoading());
    try {
      final now = DateTime.now();
      final endDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
      final start = range.startDate;

      final heatmap = await _getHeatmapData(start, endDay);
      final columns = await _getColumnData(start, endDay);
      final pieSlices = await _getPieData(start, endDay);

      final totalSeconds = pieSlices.fold(0, (s, p) => s + p.totalSeconds);

      emit(
        StatsLoaded(
          heatmap: heatmap,
          columns: columns,
          pieSlices: pieSlices,
          range: range,
          totalWorkSeconds: totalSeconds,
        ),
      );
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }

  Future<void> changeRange(StatsRange range) => loadStats(range);
}
