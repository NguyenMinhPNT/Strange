import 'package:injectable/injectable.dart';

import '../entities/day_stat.dart';
import '../repositories/stats_repository.dart';

@injectable
class GetHeatmapDataUsecase {
  const GetHeatmapDataUsecase(this._repository);

  final StatsRepository _repository;

  Future<List<DayStat>> call(DateTime start, DateTime end) =>
      _repository.getHeatmapData(start, end);
}
