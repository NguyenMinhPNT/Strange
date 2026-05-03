import 'package:injectable/injectable.dart';

import '../repositories/card_repository.dart';

@lazySingleton
class RestoreCardUseCase {
  const RestoreCardUseCase(this._repository);

  final CardRepository _repository;

  Future<void> call(int id) => _repository.restoreCard(id);
}
