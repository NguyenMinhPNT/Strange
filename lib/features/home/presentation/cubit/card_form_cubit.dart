import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/enums/card_type.dart';
import '../../domain/usecases/create_card_usecase.dart';
import '../../domain/usecases/get_card_by_id_usecase.dart';
import '../../domain/usecases/update_card_usecase.dart';
import 'card_form_state.dart';

@injectable
class CardFormCubit extends Cubit<CardFormState> {
  CardFormCubit(
    this._createCard,
    this._updateCard,
    this._getCardById,
  ) : super(CardFormInitial());

  final CreateCardUseCase _createCard;
  final UpdateCardUseCase _updateCard;
  final GetCardByIdUseCase _getCardById;

  void initForCreate(CardType defaultType) {
    emit(
      CardFormReady(
        name: '',
        colorHex: '#D52B1E',
        type: defaultType,
        isValid: false,
      ),
    );
  }

  Future<void> initForEdit(int cardId) async {
    emit(CardFormLoading());
    try {
      final card = await _getCardById(cardId);
      if (card == null) {
        emit(CardFormError('Card not found'));
        return;
      }
      emit(
        CardFormReady(
          name: card.name,
          colorHex: card.colorHex,
          type: card.type,
          isValid: true,
          editingCardId: cardId,
        ),
      );
    } catch (e) {
      emit(CardFormError(e.toString()));
    }
  }

  void changeName(String value) {
    final current = state;
    if (current is! CardFormReady) return;
    emit(
      current.copyWith(
        name: value,
        isValid: value.trim().isNotEmpty,
      ),
    );
  }

  void changeColor(String hexValue) {
    final current = state;
    if (current is! CardFormReady) return;
    emit(current.copyWith(colorHex: hexValue));
  }

  void changeType(CardType type) {
    final current = state;
    if (current is! CardFormReady) return;
    emit(current.copyWith(type: type));
  }

  Future<void> submitForm() async {
    final current = state;
    if (current is! CardFormReady || !current.isValid) return;

    emit(CardFormSubmitting());
    try {
      if (current.isEditing) {
        await _updateCard(
          UpdateCardParams(
            id: current.editingCardId!,
            name: current.name.trim(),
            colorHex: current.colorHex,
          ),
        );
      } else {
        await _createCard(
          CreateCardParams(
            name: current.name.trim(),
            colorHex: current.colorHex,
            type: current.type,
          ),
        );
      }
      emit(CardFormSuccess());
    } catch (e) {
      emit(CardFormError(e.toString()));
    }
  }
}
