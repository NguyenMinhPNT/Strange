import 'package:injectable/injectable.dart';

import '../../domain/entities/stats_card.dart';
import '../../domain/entities/column_data.dart';
import '../../domain/entities/day_stat.dart';
import '../../domain/entities/pie_slice.dart';
import '../../domain/repositories/stats_repository.dart';
import '../datasources/stats_local_datasource.dart';

@LazySingleton(as: StatsRepository)
class StatsRepositoryImpl implements StatsRepository {
  const StatsRepositoryImpl(this._datasource);

  final StatsLocalDatasource _datasource;

  @override
  Future<List<DayStat>> getHeatmapData(DateTime start, DateTime end,
          [int? cardId]) =>
      _datasource.getHeatmapData(start, end, cardId);

  @override
  Future<List<ColumnData>> getColumnData(DateTime start, DateTime end,
          [int? cardId]) =>
      _datasource.getColumnData(start, end, cardId);

  @override
  Future<List<PieSlice>> getPieData(DateTime start, DateTime end,
          [int? cardId]) =>
      _datasource.getPieData(start, end, cardId);

  @override
  Future<List<StatsCard>> getAllCards() => _datasource.getAllCards();
}
