import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/card_dao.dart';
import '../../../../core/database/daos/session_dao.dart';
import '../../domain/entities/enums/card_type.dart';
import '../../domain/entities/strange_card.dart';
import '../../domain/repositories/card_repository.dart';
import '../models/card_model.dart';

@LazySingleton(as: CardRepository)
class CardRepositoryImpl implements CardRepository {
  const CardRepositoryImpl(this._cardDao, this._sessionDao);

  final CardDao _cardDao;
  final SessionDao _sessionDao;

  @override
  Stream<List<StrangeCard>> watchCardsByType(CardType type) =>
      _cardDao.watchCardsByType(type.value).map(
            (rows) => rows.map((r) => r.toEntity()).toList(),
          );

  @override
  Future<List<StrangeCard>> getCardsByType(CardType type) async {
    final rows = await _cardDao.getCardsByType(type.value);
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<StrangeCard?> getCardById(int id) async {
    final row = await _cardDao.getCardById(id);
    return row?.toEntity();
  }

  @override
  Future<int> createCard({
    required String name,
    required String colorHex,
    required CardType type,
  }) async {
    // Determine next position: one past the last card in this type
    final existing = await _cardDao.getCardsByType(type.value);
    final position = existing.length;

    final now = DateTime.now();
    return _cardDao.insertCard(
      CardsCompanion.insert(
        name: name,
        colorHex: Value(colorHex),
        type: type.value,
        position: Value(position),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  @override
  Future<void> updateCard({
    required int id,
    required String name,
    required String colorHex,
  }) async {
    final row = await _cardDao.getCardById(id);
    if (row == null) return;
    await _cardDao.updateCard(
      CardsCompanion(
        id: Value(row.id),
        name: Value(name),
        colorHex: Value(colorHex),
        type: Value(row.type),
        position: Value(row.position),
        status: Value(row.status),
        createdAt: Value(row.createdAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> deleteCard(int id) async {
    await _sessionDao.deleteSessionsForCard(id);
    await _cardDao.deleteCardById(id);
  }

  @override
  Future<void> archiveCard(int id) async {
    final row = await _cardDao.getCardById(id);
    if (row == null) return;
    await _cardDao.updateCard(
      CardsCompanion(
        id: Value(row.id),
        name: Value(row.name),
        colorHex: Value(row.colorHex),
        type: Value(row.type),
        position: Value(row.position),
        status: const Value('archived'),
        createdAt: Value(row.createdAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> restoreCard(int id) async {
    final row = await _cardDao.getCardById(id);
    if (row == null) return;
    // Find the next position for this type
    final existing = await _cardDao.getCardsByType(row.type);
    final position = existing.length;
    await _cardDao.updateCard(
      CardsCompanion(
        id: Value(row.id),
        name: Value(row.name),
        colorHex: Value(row.colorHex),
        type: Value(row.type),
        position: Value(position),
        status: const Value('active'),
        createdAt: Value(row.createdAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> reorderCards(List<int> orderedIds) async {
    final now = DateTime.now();
    final companions = <CardsCompanion>[];
    for (var i = 0; i < orderedIds.length; i++) {
      final row = await _cardDao.getCardById(orderedIds[i]);
      if (row == null) continue;
      companions.add(
        CardsCompanion(
          id: Value(row.id),
          name: Value(row.name),
          colorHex: Value(row.colorHex),
          type: Value(row.type),
          position: Value(i),
          status: Value(row.status),
          createdAt: Value(row.createdAt),
          updatedAt: Value(now),
        ),
      );
    }
    if (companions.isNotEmpty) {
      await _cardDao.reorderCards(companions);
    }
  }
}
