import '../../domain/entities/enums/card_type.dart';

sealed class CardFormState {}

final class CardFormInitial extends CardFormState {}

final class CardFormLoading extends CardFormState {}

final class CardFormReady extends CardFormState {
  CardFormReady({
    required this.name,
    required this.colorHex,
    required this.type,
    required this.isValid,
    this.editingCardId,
  });

  final String name;
  final String colorHex;
  final CardType type;
  final bool isValid;
  final int? editingCardId;

  bool get isEditing => editingCardId != null;

  CardFormReady copyWith({
    String? name,
    String? colorHex,
    CardType? type,
    bool? isValid,
    int? editingCardId,
  }) =>
      CardFormReady(
        name: name ?? this.name,
        colorHex: colorHex ?? this.colorHex,
        type: type ?? this.type,
        isValid: isValid ?? this.isValid,
        editingCardId: editingCardId ?? this.editingCardId,
      );
}

final class CardFormSubmitting extends CardFormState {}

final class CardFormSuccess extends CardFormState {}

final class CardFormError extends CardFormState {
  CardFormError(this.message);
  final String message;
}
