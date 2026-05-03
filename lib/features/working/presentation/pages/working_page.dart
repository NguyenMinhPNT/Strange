import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection_container.dart';
import '../../../../app/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/claymorphism/clay_theme.dart';
import '../cubit/working_cubit.dart';
import '../cubit/working_state.dart';

class WorkingPage extends StatelessWidget {
  const WorkingPage({super.key, required this.cardId});

  final int cardId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WorkingCubit>()..loadCard(cardId),
      child: _WorkingView(cardId: cardId),
    );
  }
}

class _WorkingView extends StatelessWidget {
  const _WorkingView({required this.cardId});

  final int cardId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkingCubit, WorkingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: _bgColor(state, context),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              state is WorkingLoaded ? state.card.name : 'Working',
              style: AppTextStyles.bodyBold,
            ),
            leading: BackButton(
              onPressed: () => context.pop(),
            ),
          ),
          body: switch (state) {
            WorkingInitial() || WorkingLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            WorkingError(:final message) => Center(child: Text(message)),
            WorkingLoaded(:final card) => Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    // Card colour chip
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: _cardColor(card.colorHex),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _cardColor(card.colorHex)
                                  .withValues(alpha: 0.35),
                              offset: const Offset(0, 6),
                              blurRadius: 14,
                            ),
                          ],
                        ),
                        child: Text(
                          card.name,
                          style: AppTextStyles.cardName.copyWith(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Pomodoro button
                    _TimerTypeButton(
                      emoji: '🍅',
                      title: 'Pomodoro',
                      subtitle: 'Focus rounds with breaks',
                      onTap: () =>
                          context.push(RoutePaths.pomodoroPath(cardId)),
                    ),
                    const SizedBox(height: 20),
                    // Deep Work button
                    _TimerTypeButton(
                      emoji: '🧠',
                      title: 'Deep Work',
                      subtitle: 'Open-ended focused session',
                      onTap: () =>
                          context.push(RoutePaths.deepWorkPath(cardId)),
                    ),
                  ],
                ),
              ),
          },
        );
      },
    );
  }

  Color _bgColor(WorkingState state, BuildContext context) {
    if (state is WorkingLoaded) {
      return _cardColor(state.card.colorHex).withValues(alpha: 0.06);
    }
    return context.isDark ? AppColors.darkSurfaceBase : AppColors.surfaceBase;
  }

  Color _cardColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.primary;
    }
  }
}

class _TimerTypeButton extends StatelessWidget {
  const _TimerTypeButton({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: context.clayRaised(radius: 20),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.bodyBold.copyWith(fontSize: 16)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    )),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
