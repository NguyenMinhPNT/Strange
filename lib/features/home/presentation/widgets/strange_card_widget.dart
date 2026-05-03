import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_paths.dart';
import '../../../../../core/extensions/color_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/claymorphism/clay_theme.dart';
import '../../domain/entities/strange_card.dart';
import '../cubit/home_cubit.dart';

/// A single clay card widget displayed in the card list.
///
/// - Tap: navigate to WorkingPage
/// - Long-press + drag: reorder (handled by parent ReorderableListView)
/// - Swipe right → left: delete with confirmation dialog
/// - Swipe left → right: archive with undo snackbar
class StrangeCardWidget extends StatelessWidget {
  const StrangeCardWidget({
    super.key,
    required this.card,
    required this.index,
  });

  final StrangeCard card;
  final int index;

  @override
  Widget build(BuildContext context) {
    final cardColor = StringColorExtensions(card.colorHex).toColor();

    return Dismissible(
      key: ValueKey(card.id),
      // Swipe end→start (right to left) = DELETE
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return _confirmDelete(context);
        }
        // Swipe start→end (left to right) = ARCHIVE
        _archiveWithUndo(context);
        return false; // We handle it ourselves to allow undo
      },
      background: _ArchiveBackground(),
      secondaryBackground: _DeleteBackground(),
      child: _CardBody(card: card, cardColor: cardColor),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Card?'),
        content: Text(
          'Are you sure you want to permanently delete "${card.name}"? '
          'All sessions for this card will also be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, true);
              context.read<HomeCubit>().deleteCard(card.id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _archiveWithUndo(BuildContext context) {
    context.read<HomeCubit>().archiveCard(card.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('"${card.name}" archived'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => context.read<HomeCubit>().restoreCard(card.id),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
  }
}

class _CardBody extends StatefulWidget {
  const _CardBody({required this.card, required this.cardColor});

  final StrangeCard card;
  final Color cardColor;

  @override
  State<_CardBody> createState() => _CardBodyState();
}

class _CardBodyState extends State<_CardBody> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        context.push(RoutePaths.workingPath(widget.card.id));
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          margin: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space8,
          ),
          decoration: context.clayColoredCard(
            cardColor: widget.cardColor,
            isPressed: _isPressed,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space20,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.card.name,
                  style: AppTextStyles.cardName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppDimensions.space8),
              // Drag handle hint
              Icon(
                Icons.drag_handle,
                color: AppColors.onPrimary.withValues(alpha: 0.6),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArchiveBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      decoration: BoxDecoration(
        color: AppColors.goldAccent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: AppDimensions.space24),
      child: const Icon(Icons.archive_outlined, color: Colors.white, size: 28),
    );
  }
}

class _DeleteBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppDimensions.space24),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
    );
  }
}
