import '../../../home/domain/entities/strange_card.dart';

sealed class WorkingState {}

final class WorkingInitial extends WorkingState {}

final class WorkingLoading extends WorkingState {}

final class WorkingLoaded extends WorkingState {
  WorkingLoaded({required this.card});
  final StrangeCard card;
}

final class WorkingError extends WorkingState {
  WorkingError(this.message);
  final String message;
}
