import '../entities/enums/card_type.dart';
import '../entities/strange_card.dart';

abstract interface class CardRepository {
  /// Watch active cards of a given type as a reactive stream.
  Stream<List<StrangeCard>> watchCardsByType(CardType type);

  /// Get active (or archived) cards of a given type.
  Future<List<StrangeCard>> getCardsByType(CardType type);

  /// Get a single card by id, or null if not found.
  Future<StrangeCard?> getCardById(int id);

  /// Create a new card. Returns the new card's id.
  Future<int> createCard({
    required String name,
    required String colorHex,
    required CardType type,
  });

  /// Update name and color of an existing card.
  Future<void> updateCard({
    required int id,
    required String name,
    required String colorHex,
  });

  /// Permanently delete a card (sessions cascade via DAO).
  Future<void> deleteCard(int id);

  /// Archive a card (sets status = 'archived').
  Future<void> archiveCard(int id);

  /// Restore an archived card (sets status = 'active').
  Future<void> restoreCard(int id);

  /// Reorder cards by persisting a new ordered list of card IDs.
  /// Each card's position is set to its index in [orderedIds].
  Future<void> reorderCards(List<int> orderedIds);
}
