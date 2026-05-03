import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../../app/di/injection_container.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/clay_button.dart';
import '../../domain/entities/enums/card_type.dart';
import '../cubit/card_form_cubit.dart';
import '../cubit/card_form_state.dart';

/// [extra] from GoRouter: the pre-selected [CardType] when creating.
class CardFormPage extends StatelessWidget {
  const CardFormPage({super.key, this.cardId, this.initialType});

  final int? cardId;
  final CardType? initialType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<CardFormCubit>();
        if (cardId != null) {
          cubit.initForEdit(cardId!);
        } else {
          cubit.initForCreate(initialType ?? CardType.learning);
        }
        return cubit;
      },
      child: _CardFormView(isEditing: cardId != null),
    );
  }
}

class _CardFormView extends StatefulWidget {
  const _CardFormView({required this.isEditing});

  final bool isEditing;

  @override
  State<_CardFormView> createState() => _CardFormViewState();
}

class _CardFormViewState extends State<_CardFormView> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CardFormCubit, CardFormState>(
      listener: (context, state) {
        if (state is CardFormReady && _nameController.text != state.name) {
          _nameController.text = state.name;
          _nameController.selection = TextSelection.collapsed(
            offset: state.name.length,
          );
        }
        if (state is CardFormSuccess) {
          Navigator.pop(context);
        }
        if (state is CardFormError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading =
            state is CardFormLoading || state is CardFormSubmitting;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.isEditing ? 'Edit Card' : 'New Card',
              style: AppTextStyles.appTitle,
            ),
            centerTitle: true,
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : state is CardFormReady
                  ? _buildForm(context, state)
                  : const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context, CardFormReady state) {
    final cubit = context.read<CardFormCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Name
          Text('Card Name', style: AppTextStyles.sectionHeader),
          const SizedBox(height: AppDimensions.space8),
          TextField(
            controller: _nameController,
            maxLength: AppConstants.cardMaxNameLength,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'e.g. Flutter Development',
            ),
            onChanged: cubit.changeName,
          ),
          const SizedBox(height: AppDimensions.space24),

          // Color Picker
          Text('Card Color', style: AppTextStyles.sectionHeader),
          const SizedBox(height: AppDimensions.space12),
          _ColorPicker(
            selectedHex: state.colorHex,
            onColorSelected: cubit.changeColor,
          ),
          const SizedBox(height: AppDimensions.space32),

          // Submit button
          ClayButton(
            label: state.isEditing ? 'Save Changes' : 'Create Card',
            width: double.infinity,
            isEnabled: state.isValid,
            onTap: state.isValid ? cubit.submitForm : null,
          ),
        ],
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({
    required this.selectedHex,
    required this.onColorSelected,
  });

  final String selectedHex;
  final ValueChanged<String> onColorSelected;

  @override
  Widget build(BuildContext context) {
    final selectedColor = StringColorExtensions(selectedHex).toColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppDimensions.space12,
          runSpacing: AppDimensions.space12,
          children: [
            ...AppColors.cardPresets.map(
              (color) => _ColorSwatch(
                color: color,
                isSelected:
                    ColorExtensions(color).toHex() == selectedHex.toUpperCase(),
                onTap: () => onColorSelected(ColorExtensions(color).toHex()),
              ),
            ),
            // Custom color button
            GestureDetector(
              onTap: () => _openCustomPicker(context, selectedColor),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                  color: AppColors.surfaceMuted,
                ),
                child: const Icon(
                  Icons.colorize,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.space12),
        // Preview
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                boxShadow: [
                  BoxShadow(
                    color: selectedColor.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.space12),
            Text(
              selectedHex.toUpperCase(),
              style: AppTextStyles.bodyBold.copyWith(
                fontFamily: 'monospace',
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _openCustomPicker(BuildContext context, Color current) {
    Color pickerColor = current;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (c) => pickerColor = c,
            enableAlpha: false,
            hexInputBar: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onColorSelected(ColorExtensions(pickerColor).toHex());
            },
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: isSelected ? 0.5 : 0.3),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : null,
      ),
    );
  }
}
