import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums/card_status.dart';
import 'enums/card_type.dart';

part 'strange_card.freezed.dart';

@freezed
class StrangeCard with _$StrangeCard {
  const factory StrangeCard({
    required int id,
    required String name,
    required String colorHex,
    required CardType type,
    required CardStatus status,
    required int position,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StrangeCard;
}
