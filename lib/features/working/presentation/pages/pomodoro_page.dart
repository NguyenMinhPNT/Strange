import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/claymorphism/clay_theme.dart';
import '../../../settings/domain/entities/pomodoro_settings.dart';
import '../../domain/entities/enums/pomodoro_phase.dart';
import '../cubit/pomodoro_cubit.dart';
import '../cubit/pomodoro_state.dart';
import '../widgets/circular_countdown.dart';
import '../widgets/round_dots_widget.dart';
import '../widgets/timer_control_buttons.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key, required this.cardId});

  final int cardId;

  @override
  Widget build(BuildContext context) {
    // Read settings from prefs — Sprint 5 will inject SettingsCubit;
    // for now we use defaults pulled directly from TimerPreferences.
    final settings = getIt<PomodoroSettings>();

    return BlocProvider(
      create: (_) => getIt<PomodoroCubit>(),
      child: _PomodoroView(cardId: cardId, settings: settings),
    );
  }
}

class _PomodoroView extends StatefulWidget {
  const _PomodoroView({required this.cardId, required this.settings});

  final int cardId;
  final PomodoroSettings settings;

  @override
  State<_PomodoroView> createState() => _PomodoroViewState();
}

class _PomodoroViewState extends State<_PomodoroView> {
  bool _sessionStarted = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _confirmExit(context);
        if (shouldPop && context.mounted) context.pop();
      },
      child: Scaffold(
        backgroundColor:
            context.isDark ? AppColors.darkSurfaceBase : AppColors.surfaceBase,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Pomodoro'),
          leading: BackButton(
            onPressed: () async {
              final shouldPop = await _confirmExit(context);
              if (shouldPop && context.mounted) context.pop();
            },
          ),
        ),
        body: BlocConsumer<PomodoroCubit, PomodoroState>(
          listener: (context, state) {
            if (state is PomodoroEnded) {
              _showCompletionAndPop(context, state);
            } else if (state is PomodoroError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return _buildBody(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PomodoroState state) {
    return switch (state) {
      PomodoroInitial() => _buildInitialView(context),
      PomodoroRunning(
        :final phase,
        :final round,
        :final remainingSeconds,
        :final progress,
        :final completedRounds,
        :final shortBreakInterval
      ) =>
        _buildTimerView(
          context,
          phase: phase,
          round: round,
          remainingSeconds: remainingSeconds,
          progress: progress,
          completedRounds: completedRounds,
          shortBreakInterval: shortBreakInterval,
          isRunning: true,
          isPaused: false,
        ),
      PomodoroPaused(
        :final phase,
        :final round,
        :final remainingSeconds,
        :final progress,
        :final completedRounds,
        :final shortBreakInterval
      ) =>
        _buildTimerView(
          context,
          phase: phase,
          round: round,
          remainingSeconds: remainingSeconds,
          progress: progress,
          completedRounds: completedRounds,
          shortBreakInterval: shortBreakInterval,
          isRunning: false,
          isPaused: true,
        ),
      PomodoroPhaseComplete(:final completedRounds, :final nextPhase) =>
        _buildPhaseComplete(context, completedRounds, nextPhase),
      PomodoroEnded() => const Center(child: CircularProgressIndicator()),
      PomodoroError(:final message) => Center(child: Text(message)),
    };
  }

  Widget _buildInitialView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularCountdown(
            phase: PomodoroPhase.work,
            progress: 0,
            remainingSeconds: widget.settings.workDurationSeconds,
            isRunning: false,
          ),
          const SizedBox(height: 40),
          _SettingsSummary(settings: widget.settings),
          const SizedBox(height: 40),
          TimerControlButtons(
            mode: TimerControlMode.initial,
            onStart: () {
              setState(() => _sessionStarted = true);
              context.read<PomodoroCubit>().startSession(
                    widget.cardId,
                    widget.settings,
                  );
            },
            onPause: () {},
            onResume: () {},
            onEnd: () => context.pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerView(
    BuildContext context, {
    required PomodoroPhase phase,
    required int round,
    required int remainingSeconds,
    required double progress,
    required int completedRounds,
    required int shortBreakInterval,
    required bool isRunning,
    required bool isPaused,
  }) {
    final cubit = context.read<PomodoroCubit>();
    final isBreak =
        phase == PomodoroPhase.shortBreak || phase == PomodoroPhase.longBreak;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Round $round',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          CircularCountdown(
            phase: phase,
            progress: progress,
            remainingSeconds: remainingSeconds,
            isRunning: isRunning,
          ),
          const SizedBox(height: 24),
          RoundDotsWidget(
            completedRounds: completedRounds,
            shortBreakInterval: shortBreakInterval,
          ),
          const SizedBox(height: 40),
          TimerControlButtons(
            mode: isPaused ? TimerControlMode.paused : TimerControlMode.running,
            onStart: () {},
            onPause: cubit.pause,
            onResume: cubit.resume,
            onEnd: () => _handleEnd(context),
            onSkipBreak: isBreak ? cubit.skipBreak : null,
            showSkipBreak: isBreak,
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseComplete(
    BuildContext context,
    int completedRounds,
    PomodoroPhase nextPhase,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            completedRounds > 0
                ? '🎉 Round $completedRounds done!'
                : '⏸ Break over!',
            style: AppTextStyles.bodyBold.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            'Next: ${nextPhase.displayLabel}',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          const CircularProgressIndicator(color: AppColors.primary),
        ],
      ),
    );
  }

  Future<bool> _confirmExit(BuildContext context) async {
    if (!_sessionStarted) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('End session?'),
        content: const Text(
            'Your Pomodoro session is in progress. End it and save progress?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep going'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('End session',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _handleEnd(BuildContext context) async {
    final confirmed = await _confirmExit(context);
    if (confirmed && context.mounted) {
      context.read<PomodoroCubit>().endSession();
    }
  }

  void _showCompletionAndPop(BuildContext context, PomodoroEnded state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🍅', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              'Session saved!',
              style: AppTextStyles.bodyBold.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              '${state.roundsCompleted} rounds · ${_formatMinutes(state.totalWorkSeconds)} focused',
              style: AppTextStyles.body,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String _formatMinutes(int seconds) {
    final m = seconds ~/ 60;
    if (m < 60) return '${m}m';
    return '${m ~/ 60}h ${m % 60}m';
  }
}

class _SettingsSummary extends StatelessWidget {
  const _SettingsSummary({required this.settings});

  final PomodoroSettings settings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: context.clayRaised(radius: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _Item('Work', '${settings.workDurationMinutes}m'),
          _Divider(),
          _Item('Short break', '${settings.shortBreakMinutes}m'),
          _Divider(),
          _Item('Long break', '${settings.longBreakMinutes}m'),
          _Divider(),
          _Item('Interval', '${settings.shortBreakInterval} rounds'),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value,
              style: AppTextStyles.bodyBold
                  .copyWith(color: AppColors.primary, fontSize: 13)),
          Text(label,
              style: AppTextStyles.body
                  .copyWith(color: AppColors.textSecondary, fontSize: 11)),
        ],
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 28,
        color: AppColors.surfaceMuted,
      );
}
