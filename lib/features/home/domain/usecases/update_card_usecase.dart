import 'package:injectable/injectable.dart';

import '../repositories/card_repository.dart';

class UpdateCardParams {
  const UpdateCardParams({
    required this.id,
    required this.name,
    required this.colorHex,
  });

  final int id;
  final String name;
  final String colorHex;
}

@lazySingleton
class UpdateCardUseCase {
  const UpdateCardUseCase(this._repository);

  final CardRepository _repository;

  Future<void> call(UpdateCardParams params) => _repository.updateCard(
        id: params.id,
        name: params.name,
        colorHex: params.colorHex,
      );
}
