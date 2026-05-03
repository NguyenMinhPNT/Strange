import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/claymorphism/clay_theme.dart';
import '../../../settings/domain/entities/deep_work_settings.dart';
import '../cubit/deep_work_cubit.dart';
import '../cubit/deep_work_state.dart';
import '../widgets/pause_bar_indicator.dart';
import '../widgets/stopwatch_display.dart';
import '../widgets/timer_control_buttons.dart';

class DeepWorkPage extends StatelessWidget {
  const DeepWorkPage({super.key, required this.cardId});

  final int cardId;

  @override
  Widget build(BuildContext context) {
    final settings = getIt<DeepWorkSettings>();
    return BlocProvider(
      create: (_) => getIt<DeepWorkCubit>(),
      child: _DeepWorkView(cardId: cardId, settings: settings),
    );
  }
}

class _DeepWorkView extends StatefulWidget {
  const _DeepWorkView({required this.cardId, required this.settings});

  final int cardId;
  final DeepWorkSettings settings;

  @override
  State<_DeepWorkView> createState() => _DeepWorkViewState();
}

class _DeepWorkViewState extends State<_DeepWorkView> {
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
          title: const Text('Deep Work'),
          leading: BackButton(
            onPressed: () async {
              final shouldPop = await _confirmExit(context);
              if (shouldPop && context.mounted) context.pop();
            },
          ),
        ),
        body: BlocConsumer<DeepWorkCubit, DeepWorkState>(
          listener: (context, state) {
            if (state is DeepWorkEnded || state is DeepWorkAutoEnded) {
              _showCompletionAndPop(context, state);
            } else if (state is DeepWorkError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text((state).message)),
              );
            }
          },
          builder: (context, state) => _buildBody(context, state),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, DeepWorkState state) {
    return switch (state) {
      DeepWorkInitial() => _buildInitialView(context),
      DeepWorkRunning(:final elapsedWorkSeconds) => _buildRunningView(
          context,
          elapsedWorkSeconds: elapsedWorkSeconds,
        ),
      DeepWorkPaused(
        :final elapsedWorkSeconds,
        :final pauseElapsedSeconds,
        :final maxPauseSeconds
      ) =>
        _buildPausedView(
          context,
          elapsedWorkSeconds: elapsedWorkSeconds,
          pauseElapsedSeconds: pauseElapsedSeconds,
          maxPauseSeconds: maxPauseSeconds,
        ),
      DeepWorkEnded() ||
      DeepWorkAutoEnded() =>
        const Center(child: CircularProgressIndicator()),
      DeepWorkError(:final message) => Center(child: Text(message)),
    };
  }

  Widget _buildInitialView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🧠', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 24),
          Text(
            'Deep Work',
            style: AppTextStyles.bodyBold.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 8),
          Text(
            'Open-ended focused session.\nPause budget: ${widget.settings.maxPauseSeconds ~/ 60}m',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 48),
          TimerControlButtons(
            mode: TimerControlMode.initial,
            onStart: () {
              setState(() => _sessionStarted = true);
              context.read<DeepWorkCubit>().startSession(
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

  Widget _buildRunningView(
    BuildContext context, {
    required int elapsedWorkSeconds,
  }) {
    final cubit = context.read<DeepWorkCubit>();
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StopwatchDisplay(
            elapsedWorkSeconds: elapsedWorkSeconds,
            isPaused: false,
          ),
          const SizedBox(height: 56),
          TimerControlButtons(
            mode: TimerControlMode.running,
            onStart: () {},
            onPause: cubit.pause,
            onResume: () {},
            onEnd: () => _handleEnd(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPausedView(
    BuildContext context, {
    required int elapsedWorkSeconds,
    required int pauseElapsedSeconds,
    required int maxPauseSeconds,
  }) {
    final cubit = context.read<DeepWorkCubit>();
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StopwatchDisplay(
            elapsedWorkSeconds: elapsedWorkSeconds,
            isPaused: true,
          ),
          const SizedBox(height: 32),
          PauseBarIndicator(
            pauseElapsedSeconds: pauseElapsedSeconds,
            maxPauseSeconds: maxPauseSeconds,
          ),
          const SizedBox(height: 40),
          TimerControlButtons(
            mode: TimerControlMode.paused,
            onStart: () {},
            onPause: () {},
            onResume: cubit.resume,
            onEnd: () => _handleEnd(context),
          ),
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
        content:
            const Text('Your Deep Work session is active. End it and save?'),
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
      context.read<DeepWorkCubit>().endSession();
    }
  }

  void _showCompletionAndPop(BuildContext context, DeepWorkState state) {
    final (workSec, isAuto) = switch (state) {
      DeepWorkEnded(:final totalWorkSeconds) => (totalWorkSeconds, false),
      DeepWorkAutoEnded(:final totalWorkSeconds) => (totalWorkSeconds, true),
      _ => (0, false),
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isAuto ? '⚠️' : '🧠', style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              isAuto ? 'Max pause exceeded' : 'Session saved!',
              style: AppTextStyles.bodyBold.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              '${_formatMinutes(workSec)} focused',
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
