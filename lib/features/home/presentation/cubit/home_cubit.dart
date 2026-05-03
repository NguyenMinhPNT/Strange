import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/enums/card_type.dart';
import '../../domain/entities/strange_card.dart';
import '../../domain/usecases/archive_card_usecase.dart';
import '../../domain/usecases/create_card_usecase.dart';
import '../../domain/usecases/delete_card_usecase.dart';
import '../../domain/usecases/reorder_cards_usecase.dart';
import '../../domain/usecases/restore_card_usecase.dart';
import '../../domain/usecases/update_card_usecase.dart';
import '../../domain/usecases/watch_cards_by_type_usecase.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._watchCardsByType,
    this._createCard,
    this._updateCard,
    this._deleteCard,
    this._archiveCard,
    this._restoreCard,
    this._reorderCards,
  ) : super(HomeInitial());

  final WatchCardsByTypeUseCase _watchCardsByType;
  final CreateCardUseCase _createCard;
  final UpdateCardUseCase _updateCard;
  final DeleteCardUseCase _deleteCard;
  final ArchiveCardUseCase _archiveCard;
  final RestoreCardUseCase _restoreCard;
  final ReorderCardsUseCase _reorderCards;

  StreamSubscription<List<StrangeCard>>? _learningSub;
  StreamSubscription<List<StrangeCard>>? _projectSub;
  StreamSubscription<List<StrangeCard>>? _habitSub;

  List<StrangeCard> _learningCards = [];
  List<StrangeCard> _projectCards = [];
  List<StrangeCard> _habitCards = [];

  void loadCards() {
    emit(HomeLoading());

    _learningSub?.cancel();
    _projectSub?.cancel();
    _habitSub?.cancel();

    _learningSub = _watchCardsByType(CardType.learning).listen(
      (cards) {
        _learningCards = cards;
        _emitLoaded();
      },
      onError: (Object e) => emit(HomeError(e.toString())),
    );

    _projectSub = _watchCardsByType(CardType.project).listen(
      (cards) {
        _projectCards = cards;
        _emitLoaded();
      },
      onError: (Object e) => emit(HomeError(e.toString())),
    );

    _habitSub = _watchCardsByType(CardType.habit).listen(
      (cards) {
        _habitCards = cards;
        _emitLoaded();
      },
      onError: (Object e) => emit(HomeError(e.toString())),
    );
  }

  void _emitLoaded() {
    emit(
      HomeLoaded(
        learningCards: List.unmodifiable(_learningCards),
        projectCards: List.unmodifiable(_projectCards),
        habitCards: List.unmodifiable(_habitCards),
      ),
    );
  }

  Future<void> addCard(
    String name,
    String colorHex,
    CardType type,
  ) async {
    try {
      await _createCard(
        CreateCardParams(name: name, colorHex: colorHex, type: type),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> updateCard(int id, String name, String colorHex) async {
    try {
      await _updateCard(
        UpdateCardParams(id: id, name: name, colorHex: colorHex),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> deleteCard(int id) async {
    try {
      await _deleteCard(id);
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> archiveCard(int id) async {
    try {
      await _archiveCard(id);
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> restoreCard(int id) async {
    try {
      await _restoreCard(id);
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> reorderCards(
    CardType type,
    int oldIndex,
    int newIndex,
  ) async {
    final current = state;
    if (current is! HomeLoaded) return;

    List<StrangeCard> cards;
    switch (type) {
      case CardType.learning:
        cards = List.of(current.learningCards);
      case CardType.project:
        cards = List.of(current.projectCards);
      case CardType.habit:
        cards = List.of(current.habitCards);
    }

    // Apply the reorder locally for immediate visual feedback
    final item = cards.removeAt(oldIndex);
    cards.insert(newIndex, item);

    // Optimistically update UI
    switch (type) {
      case CardType.learning:
        _learningCards = cards;
      case CardType.project:
        _projectCards = cards;
      case CardType.habit:
        _habitCards = cards;
    }
    _emitLoaded();

    // Persist the new order
    try {
      await _reorderCards(cards.map((c) => c.id).toList());
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _learningSub?.cancel();
    _projectSub?.cancel();
    _habitSub?.cancel();
    return super.close();
  }
}
