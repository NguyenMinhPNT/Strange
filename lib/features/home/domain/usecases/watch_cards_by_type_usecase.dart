import 'package:injectable/injectable.dart';

import '../entities/enums/card_type.dart';
import '../entities/strange_card.dart';
import '../repositories/card_repository.dart';

@lazySingleton
class WatchCardsByTypeUseCase {
  const WatchCardsByTypeUseCase(this._repository);

  final CardRepository _repository;

  Stream<List<StrangeCard>> call(CardType type) =>
      _repository.watchCardsByType(type);
}
