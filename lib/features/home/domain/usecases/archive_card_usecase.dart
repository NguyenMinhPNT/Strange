import 'package:injectable/injectable.dart';

import '../repositories/card_repository.dart';

@lazySingleton
class ArchiveCardUseCase {
  const ArchiveCardUseCase(this._repository);

  final CardRepository _repository;

  Future<void> call(int id) => _repository.archiveCard(id);
}
