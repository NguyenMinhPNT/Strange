import 'package:injectable/injectable.dart';

import '../repositories/card_repository.dart';

@lazySingleton
class DeleteCardUseCase {
  const DeleteCardUseCase(this._repository);

  final CardRepository _repository;

  Future<void> call(int id) => _repository.deleteCard(id);
}
