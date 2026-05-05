import 'package:injectable/injectable.dart';

import '../entities/column_data.dart';
import '../repositories/stats_repository.dart';

@injectable
class GetColumnDataUsecase {
  const GetColumnDataUsecase(this._repository);

  final StatsRepository _repository;

  Future<List<ColumnData>> call(DateTime start, DateTime end) =>
      _repository.getColumnData(start, end);
}
