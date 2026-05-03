import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/empty_state_widget.dart';
import '../../domain/entities/enums/card_type.dart';
import '../../domain/entities/strange_card.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'strange_card_widget.dart';

/// A scrollable, reorderable list of [StrangeCard]s for one tab.
class CardTabView extends StatelessWidget {
  const CardTabView({super.key, required this.type});

  final CardType type;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HomeError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is HomeLoaded) {
          final cards = _cardsForType(state, type);
          if (cards.isEmpty) {
            return const EmptyStateWidget(
              message: 'No cards yet.\nTap + to add one!',
              icon: Icons.add_card_outlined,
            );
          }
          return _CardList(cards: cards, type: type);
        }

        return const SizedBox.shrink();
      },
    );
  }

  List<StrangeCard> _cardsForType(HomeLoaded state, CardType type) {
    switch (type) {
      case CardType.learning:
        return state.learningCards;
      case CardType.project:
        return state.projectCards;
      case CardType.habit:
        return state.habitCards;
    }
  }
}

class _CardList extends StatelessWidget {
  const _CardList({required this.cards, required this.type});

  final List<StrangeCard> cards;
  final CardType type;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: cards.length,
      proxyDecorator: (child, index, animation) => Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: animation.drive(
            Tween<double>(begin: 1.0, end: 1.03).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: child,
        ),
      ),
      onReorder: (oldIndex, newIndex) {
        if (newIndex > oldIndex) newIndex--;
        context.read<HomeCubit>().reorderCards(type, oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final card = cards[index];
        return StrangeCardWidget(
          key: ValueKey(card.id),
          card: card,
          index: index,
        );
      },
    );
  }
}
