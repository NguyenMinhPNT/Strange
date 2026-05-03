import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../home/domain/usecases/get_card_by_id_usecase.dart';
import 'working_state.dart';

@injectable
class WorkingCubit extends Cubit<WorkingState> {
  WorkingCubit(this._getCardById) : super(WorkingInitial());

  final GetCardByIdUseCase _getCardById;

  Future<void> loadCard(int cardId) async {
    emit(WorkingLoading());
    try {
      final card = await _getCardById(cardId);
      if (card == null) {
        emit(WorkingError('Card not found'));
      } else {
        emit(WorkingLoaded(card: card));
      }
    } catch (e) {
      emit(WorkingError(e.toString()));
    }
  }
}
