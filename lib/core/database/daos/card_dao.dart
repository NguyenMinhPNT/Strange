import 'package:drift/drift.dart';

import '../app_database.dart';

part 'card_dao.g.dart';

@DriftAccessor(tables: [Cards])
class CardDao extends DatabaseAccessor<AppDatabase> with _$CardDaoMixin {
  CardDao(super.db);

  /// Get all active (or archived) cards of a given type, ordered by position.
  Future<List<CardData>> getCardsByType(
    String type, {
    String status = 'active',
  }) =>
      (select(cards)
            ..where((c) => c.type.equals(type) & c.status.equals(status))
            ..orderBy([(c) => OrderingTerm.asc(c.position)]))
          .get();

  /// Watch active cards of a given type (reactive stream).
  Stream<List<CardData>> watchCardsByType(String type) => (select(cards)
        ..where((c) => c.type.equals(type) & c.status.equals('active'))
        ..orderBy([(c) => OrderingTerm.asc(c.position)]))
      .watch();

  Future<CardData?> getCardById(int id) =>
      (select(cards)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<int> insertCard(CardsCompanion companion) =>
      into(cards).insert(companion);

  Future<bool> updateCard(CardsCompanion companion) =>
      update(cards).replace(companion);

  Future<int> deleteCardById(int id) =>
      (delete(cards)..where((c) => c.id.equals(id))).go();

  Future<List<CardData>> getAllCards() => select(cards).get();

  /// Batch update position for multiple cards (reorder).
  Future<void> reorderCards(List<CardsCompanion> companions) async {
    await batch((b) {
      for (final companion in companions) {
        b.update(
          cards,
          companion,
          where: (c) => c.id.equals(companion.id.value),
        );
      }
    });
  }
}
