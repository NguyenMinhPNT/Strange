import '../entities/day_stat.dart';
import '../entities/column_data.dart';
import '../entities/pie_slice.dart';

abstract class StatsRepository {
  Future<List<DayStat>> getHeatmapData(DateTime start, DateTime end);
  Future<List<ColumnData>> getColumnData(DateTime start, DateTime end);
  Future<List<PieSlice>> getPieData(DateTime start, DateTime end);
}
