import '../../domain/entities/strange_card.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  HomeLoaded({
    required this.learningCards,
    required this.projectCards,
    required this.habitCards,
  });

  final List<StrangeCard> learningCards;
  final List<StrangeCard> projectCards;
  final List<StrangeCard> habitCards;

  HomeLoaded copyWith({
    List<StrangeCard>? learningCards,
    List<StrangeCard>? projectCards,
    List<StrangeCard>? habitCards,
  }) =>
      HomeLoaded(
        learningCards: learningCards ?? this.learningCards,
        projectCards: projectCards ?? this.projectCards,
        habitCards: habitCards ?? this.habitCards,
      );
}

final class HomeError extends HomeState {
  HomeError(this.message);
  final String message;
}
