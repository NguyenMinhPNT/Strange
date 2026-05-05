import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/enums/stats_range.dart';
import '../cubit/stats_cubit.dart';
import '../cubit/stats_state.dart';

class StatsRangeSelector extends StatelessWidget {
  const StatsRangeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsCubit, StatsState>(
      builder: (context, state) {
        final current =
            state is StatsLoaded ? state.range : StatsRange.sevenDays;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: StatsRange.values.map((range) {
            final selected = range == current;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => context.read<StatsCubit>().changeRange(range),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        selected ? AppColors.primary : AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: selected
                        ? [
                            const BoxShadow(
                              color: AppColors.clayShadowPrimary,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    range.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? AppColors.onPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
