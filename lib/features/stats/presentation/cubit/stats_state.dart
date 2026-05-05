import '../../domain/entities/column_data.dart';
import '../../domain/entities/day_stat.dart';
import '../../domain/entities/enums/stats_range.dart';
import '../../domain/entities/pie_slice.dart';

sealed class StatsState {
  const StatsState();
}

final class StatsInitial extends StatsState {
  const StatsInitial();
}

final class StatsLoading extends StatsState {
  const StatsLoading();
}

final class StatsLoaded extends StatsState {
  const StatsLoaded({
    required this.heatmap,
    required this.columns,
    required this.pieSlices,
    required this.range,
    required this.totalWorkSeconds,
  });

  final List<DayStat> heatmap;
  final List<ColumnData> columns;
  final List<PieSlice> pieSlices;
  final StatsRange range;
  final int totalWorkSeconds;
}

final class StatsError extends StatsState {
  const StatsError(this.message);

  final String message;
}
