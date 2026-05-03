import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection_container.dart';
import '../../../../app/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/claymorphism/clay_theme.dart';
import '../../../home/domain/entities/strange_card.dart';
import '../../../home/domain/usecases/get_card_by_id_usecase.dart';
import '../../../settings/domain/entities/deep_work_settings.dart';
import '../../domain/entities/enums/timer_type.dart';
import '../../domain/entities/timer_recovery_params.dart';
import '../../domain/repositories/session_repository.dart';
import '../cubit/deep_work_cubit.dart';
import '../cubit/deep_work_state.dart';
import '../widgets/deep_work_stopwatch_dial.dart';
import '../widgets/timer_screen_shared.dart';

class DeepWorkPage extends StatelessWidget {
  const DeepWorkPage({super.key, required this.cardId, this.recovery});

  final int cardId;
  final TimerRecoveryParams? recovery;

  @override
  Widget build(BuildContext context) {
    final settings = getIt<DeepWorkSettings>();
    return BlocProvider(
      create: (_) => getIt<DeepWorkCubit>(),
      child:
          _DeepWorkView(cardId: cardId, settings: settings, recovery: recovery),
    );
  }
}

class _DeepWorkView extends StatefulWidget {
  const _DeepWorkView({
    required this.cardId,
    required this.settings,
    this.recovery,
  });

  final int cardId;
  final DeepWorkSettings settings;
  final TimerRecoveryParams? recovery;

  @override
  State<_DeepWorkView> createState() => _DeepWorkViewState();
}

class _DeepWorkViewState extends State<_DeepWorkView> {
  late final Future<_DeepWorkScreenData> _screenDataFuture;
  bool _sessionStarted = false;

  @override
  void initState() {
    super.initState();
    _screenDataFuture = _loadScreenData();
    if (widget.recovery != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startRecovery());
    }
  }

  Future<_DeepWorkScreenData> _loadScreenData() async {
    final card = await getIt<GetCardByIdUseCase>()(widget.cardId);
    if (card == null) {
      throw StateError('Card not found');
    }

    final sessions =
        await getIt<SessionRepository>().getSessionsForCard(widget.cardId);
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final startOfTomorrow = startOfDay.add(const Duration(days: 1));

    final todayDeepWorkSessions = sessions.where(
      (session) =>
          session.timerType == TimerType.deepWork &&
          !session.startedAt.isBefore(startOfDay) &&
          session.startedAt.isBefore(startOfTomorrow),
    );

    var todayWorkSeconds = 0;
    var sessionsToday = 0;
    for (final session in todayDeepWorkSessions) {
      todayWorkSeconds += session.totalWorkSeconds;
      if (session.totalWorkSeconds > 0) {
        sessionsToday++;
      }
    }

    return _DeepWorkScreenData(
      card: card,
      todayWorkSeconds: todayWorkSeconds,
      sessionsToday: sessionsToday,
    );
  }

  void _startRecovery() {
    final recovery = widget.recovery!;
    setState(() => _sessionStarted = true);
    context.read<DeepWorkCubit>().startSession(
          widget.cardId,
          widget.settings,
          resumeElapsedWorkSec: recovery.elapsedWorkSec,
          resumeTotalPauseSec: recovery.deepWorkTotalPauseSec,
        );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _confirmExit(context);
        if (shouldPop && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor:
            context.isDark ? AppColors.darkSurfaceBase : AppColors.surfaceBase,
        body: Stack(
          children: [
            const TimerBackground(),
            SafeArea(
              child: FutureBuilder<_DeepWorkScreenData>(
                future: _screenDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(
                      child: Text(
                        snapshot.error?.toString() ?? 'Unable to load timer',
                        style: AppTextStyles.body,
                      ),
                    );
                  }

                  return BlocConsumer<DeepWorkCubit, DeepWorkState>(
                    listener: (context, state) {
                      if (state is DeepWorkEnded ||
                          state is DeepWorkAutoEnded) {
                        _showCompletionAndPop(context, state);
                      } else if (state is DeepWorkError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    builder: (context, state) {
                      return _buildBody(context, snapshot.data!, state);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    _DeepWorkScreenData screenData,
    DeepWorkState state,
  ) {
    return switch (state) {
      DeepWorkInitial() => _buildTimerScreen(
          context,
          screenData,
          display: _DeepWorkDisplay.initial(widget.settings),
          showStartOnly: true,
        ),
      DeepWorkRunning(
        :final elapsedWorkSeconds,
        :final totalPauseSeconds,
      ) =>
        _buildTimerScreen(
          context,
          screenData,
          display: _DeepWorkDisplay.live(
            elapsedWorkSeconds: elapsedWorkSeconds,
            totalPauseSeconds: totalPauseSeconds,
            maxPauseSeconds: widget.settings.maxPauseSeconds,
            isPaused: false,
          ),
        ),
      DeepWorkPaused(
        :final elapsedWorkSeconds,
        :final totalPauseSeconds,
        :final pauseElapsedSeconds,
        :final maxPauseSeconds,
        :final remainingPauseSeconds,
      ) =>
        _buildTimerScreen(
          context,
          screenData,
          display: _DeepWorkDisplay.live(
            elapsedWorkSeconds: elapsedWorkSeconds,
            totalPauseSeconds: totalPauseSeconds,
            maxPauseSeconds: maxPauseSeconds,
            isPaused: true,
            bannerText:
                'Paused. ${_formatReadableDuration(remainingPauseSeconds)} left in pause budget.',
            pauseElapsedSeconds: pauseElapsedSeconds,
          ),
        ),
      DeepWorkEnded() ||
      DeepWorkAutoEnded() =>
        const Center(child: CircularProgressIndicator()),
      DeepWorkError(:final message) => Center(child: Text(message)),
    };
  }

  Widget _buildTimerScreen(
    BuildContext context,
    _DeepWorkScreenData screenData, {
    required _DeepWorkDisplay display,
    bool showStartOnly = false,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final timerSize = math.max(260.0, math.min(width - 72, 360.0));
    final canSwitchMode = !_sessionStarted;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        children: [
          TimerTopBar(
            onBack: () async {
              final shouldPop = await _confirmExit(context);
              if (shouldPop && context.mounted) {
                context.pop();
              }
            },
          ),
          const SizedBox(height: 18),
          TimerCardInfoPanel(card: screenData.card),
          const SizedBox(height: 18),
          TimerModeSwitch(
            activeMode: TimerScreenMode.deepWork,
            onPomodoro: canSwitchMode
                ? () => context.pushReplacement(
                      RoutePaths.pomodoroPath(widget.cardId),
                    )
                : null,
            onDeepWork: null,
          ),
          if (display.bannerText != null) ...[
            const SizedBox(height: 14),
            TimerBannerChip(text: display.bannerText!),
          ],
          const SizedBox(height: 24),
          DeepWorkStopwatchDial(
            elapsedWorkSeconds: display.elapsedWorkSeconds,
            isPaused: display.isPaused,
            size: timerSize,
          ),
          const SizedBox(height: 24),
          TimerStatsStrip(
            items: [
              TimerStatItemData(
                icon: Icons.schedule_rounded,
                iconColor: AppColors.primary,
                label: 'Elapsed',
                value: _formatReadableDuration(display.elapsedWorkSeconds),
              ),
              TimerStatItemData(
                icon: Icons.hourglass_bottom_rounded,
                iconColor: const Color(0xFF4A90E2),
                label: 'Pause limit',
                value: _formatReadableDuration(display.maxPauseSeconds),
              ),
              TimerStatItemData(
                icon: Icons.pause_rounded,
                iconColor: const Color(0xFF27AE60),
                label: 'Paused',
                value: _formatReadableDuration(display.totalPauseSeconds),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildControls(
            context,
            display: display,
            showStartOnly: showStartOnly,
          ),
          const SizedBox(height: 24),
          TimerSummaryPanel(
            rows: [
              TimerSummaryRowData(
                icon: Icons.show_chart_rounded,
                iconColor: AppColors.primary,
                label: 'Today deep work',
                value: _formatReadableDuration(screenData.todayWorkSeconds),
                valueColor: AppColors.primary,
              ),
              TimerSummaryRowData(
                icon: Icons.workspace_premium_rounded,
                iconColor: const Color(0xFF4A90E2),
                label: 'Sessions today',
                value: '${screenData.sessionsToday}',
                valueColor: const Color(0xFF4A90E2),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Go deep, one distraction-free session at a time.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(
    BuildContext context, {
    required _DeepWorkDisplay display,
    required bool showStartOnly,
  }) {
    final cubit = context.read<DeepWorkCubit>();

    if (showStartOnly) {
      return TimerCenterActionButton(
        icon: Icons.play_arrow_rounded,
        onTap: () {
          setState(() => _sessionStarted = true);
          cubit.startSession(widget.cardId, widget.settings);
        },
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TimerSideActionButton(
          icon: Icons.restart_alt_rounded,
          iconColor: AppColors.primary,
          onTap: () => _restartSession(context),
        ),
        TimerCenterActionButton(
          icon:
              display.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
          onTap: display.isPaused ? cubit.resume : cubit.pause,
        ),
        TimerSideActionButton(
          icon: Icons.stop_rounded,
          iconColor: AppColors.primary,
          onTap: () => _handleEnd(context),
        ),
      ],
    );
  }

  Future<bool> _confirmExit(BuildContext context) async {
    if (!_sessionStarted) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('End session?'),
        content:
            const Text('Your Deep Work session is active. End it and save?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep going'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'End session',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _restartSession(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Restart session?'),
        content: const Text('This will reset the current Deep Work progress.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Restart',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      setState(() => _sessionStarted = true);
      context
          .read<DeepWorkCubit>()
          .startSession(widget.cardId, widget.settings);
    }
  }

  Future<void> _handleEnd(BuildContext context) async {
    final confirmed = await _confirmExit(context);
    if (confirmed && context.mounted) {
      context.read<DeepWorkCubit>().endSession();
    }
  }

  void _showCompletionAndPop(BuildContext context, DeepWorkState state) {
    final (workSeconds, isAuto) = switch (state) {
      DeepWorkEnded(:final totalWorkSeconds) => (totalWorkSeconds, false),
      DeepWorkAutoEnded(:final totalWorkSeconds) => (totalWorkSeconds, true),
      _ => (0, false),
    };

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isAuto ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
              size: 52,
              color: isAuto ? AppColors.warning : AppColors.primary,
            ),
            const SizedBox(height: 12),
            Text(
              isAuto ? 'Max pause exceeded' : 'Session saved',
              style: AppTextStyles.bodyBold.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              '${_formatReadableDuration(workSeconds)} focused',
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String _formatReadableDuration(int seconds) {
    if (seconds <= 0) return '0 min';
    final duration = Duration(seconds: seconds);
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return minutes == 0 ? '${hours}h' : '${hours}h ${minutes}m';
    }
    return '${duration.inMinutes} min';
  }
}

class _DeepWorkScreenData {
  const _DeepWorkScreenData({
    required this.card,
    required this.todayWorkSeconds,
    required this.sessionsToday,
  });

  final StrangeCard card;
  final int todayWorkSeconds;
  final int sessionsToday;
}

class _DeepWorkDisplay {
  const _DeepWorkDisplay({
    required this.elapsedWorkSeconds,
    required this.totalPauseSeconds,
    required this.maxPauseSeconds,
    required this.isPaused,
    this.bannerText,
    this.pauseElapsedSeconds = 0,
  });

  factory _DeepWorkDisplay.initial(DeepWorkSettings settings) {
    return _DeepWorkDisplay(
      elapsedWorkSeconds: 0,
      totalPauseSeconds: 0,
      maxPauseSeconds: settings.maxPauseSeconds,
      isPaused: false,
    );
  }

  factory _DeepWorkDisplay.live({
    required int elapsedWorkSeconds,
    required int totalPauseSeconds,
    required int maxPauseSeconds,
    required bool isPaused,
    String? bannerText,
    int pauseElapsedSeconds = 0,
  }) {
    return _DeepWorkDisplay(
      elapsedWorkSeconds: elapsedWorkSeconds,
      totalPauseSeconds: totalPauseSeconds,
      maxPauseSeconds: maxPauseSeconds,
      isPaused: isPaused,
      bannerText: bannerText,
      pauseElapsedSeconds: pauseElapsedSeconds,
    );
  }

  final int elapsedWorkSeconds;
  final int totalPauseSeconds;
  final int maxPauseSeconds;
  final bool isPaused;
  final String? bannerText;
  final int pauseElapsedSeconds;
}
