import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_paths.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/claymorphism/clay_styles.dart';
import '../../domain/entities/enums/card_type.dart';

/// FAB that opens the card-create form with the current tab's [CardType]
/// pre-selected.
class AddCardFab extends StatelessWidget {
  const AddCardFab({super.key, required this.selectedType});

  final CardType selectedType;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'add_card_fab',
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusFab),
      ),
      onPressed: () => context.push(
        RoutePaths.cardCreate,
        extra: selectedType,
      ),
      child: Container(
        width: AppDimensions.fabSize,
        height: AppDimensions.fabSize,
        decoration: ClayStyles.primary(radius: AppDimensions.radiusFab),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
