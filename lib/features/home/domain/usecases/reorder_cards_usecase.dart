import 'package:injectable/injectable.dart';

import '../repositories/card_repository.dart';

@lazySingleton
class ReorderCardsUseCase {
  const ReorderCardsUseCase(this._repository);

  final CardRepository _repository;

  /// [orderedIds] is the full list of card IDs in the desired display order.
  Future<void> call(List<int> orderedIds) =>
      _repository.reorderCards(orderedIds);
}
