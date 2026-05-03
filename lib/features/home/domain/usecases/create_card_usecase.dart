import 'package:injectable/injectable.dart';

import '../entities/enums/card_type.dart';
import '../repositories/card_repository.dart';

class CreateCardParams {
  const CreateCardParams({
    required this.name,
    required this.colorHex,
    required this.type,
  });

  final String name;
  final String colorHex;
  final CardType type;
}

@lazySingleton
class CreateCardUseCase {
  const CreateCardUseCase(this._repository);

  final CardRepository _repository;

  Future<int> call(CreateCardParams params) => _repository.createCard(
        name: params.name,
        colorHex: params.colorHex,
        type: params.type,
      );
}
