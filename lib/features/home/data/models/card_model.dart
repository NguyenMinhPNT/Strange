import '../../../../core/database/app_database.dart';
import '../../domain/entities/enums/card_status.dart';
import '../../domain/entities/enums/card_type.dart';
import '../../domain/entities/strange_card.dart';

/// Maps a Drift [CardData] row to the [StrangeCard] domain entity.
extension CardDataMapper on CardData {
  StrangeCard toEntity() => StrangeCard(
        id: id,
        name: name,
        colorHex: colorHex,
        type: CardType.fromString(type),
        status: CardStatus.fromString(status),
        position: position,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
