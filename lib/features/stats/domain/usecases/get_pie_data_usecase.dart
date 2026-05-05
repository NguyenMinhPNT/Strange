import 'package:injectable/injectable.dart';

import '../entities/pie_slice.dart';
import '../repositories/stats_repository.dart';

@injectable
class GetPieDataUsecase {
  const GetPieDataUsecase(this._repository);

  final StatsRepository _repository;

  Future<List<PieSlice>> call(DateTime start, DateTime end, [int? cardId]) =>
      _repository.getPieData(start, end, cardId);
}
