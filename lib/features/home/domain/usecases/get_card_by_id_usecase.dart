import 'package:injectable/injectable.dart';

import '../entities/strange_card.dart';
import '../repositories/card_repository.dart';

@lazySingleton
class GetCardByIdUseCase {
  const GetCardByIdUseCase(this._repository);

  final CardRepository _repository;

  Future<StrangeCard?> call(int id) => _repository.getCardById(id);
}
