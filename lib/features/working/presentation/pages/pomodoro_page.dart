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
import '../../../home/domain/entities/enums/card_type.dart';
import '../../../home/domain/entities/strange_card.dart';
import '../../../home/domain/usecases/get_card_by_id_usecase.dart';
import '../../../settings/domain/entities/pomodoro_settings.dart';
import '../../domain/entities/enums/pomodoro_phase.dart';
import '../../domain/entities/enums/timer_type.dart';
import '../../domain/entities/timer_recovery_params.dart';
import '../../domain/repositories/session_repository.dart';
import '../cubit/pomodoro_cubit.dart';
import '../cubit/pomodoro_state.dart';
import '../widgets/circular_countdown.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key, required this.cardId, this.recovery});

  final int cardId;
  final TimerRecoveryParams? recovery;

  @override
  Widget build(BuildContext context) {
    final settings = getIt<PomodoroSettings>();

    return BlocProvider(
      create: (_) => getIt<PomodoroCubit>(),
      child:
          _PomodoroView(cardId: cardId, settings: settings, recovery: recovery),
    );
  }
}

class _PomodoroView extends StatefulWidget {
  const _PomodoroView({
    required this.cardId,
    required this.settings,
    this.recovery,
  });

  final int cardId;
  final PomodoroSettings settings;
  final TimerRecoveryParams? recovery;

  @override
  State<_PomodoroView> createState() => _PomodoroViewState();
}

class _PomodoroViewState extends State<_PomodoroView> {
  late final Future<_PomodoroScreenData> _screenDataFuture;
  bool _sessionStarted = false;

  @override
  void initState() {
    super.initState();
    _screenDataFuture = _loadScreenData();
    if (widget.recovery != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startRecovery());
    }
  }

  Future<_PomodoroScreenData> _loadScreenData() async {
    final card = await getIt<GetCardByIdUseCase>()(widget.cardId);
    if (card == null) {
      throw StateError('Card not found');
    }

    final sessions =
        await getIt<SessionRepository>().getSessionsForCard(widget.cardId);
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final startOfTomorrow = startOfDay.add(const Duration(days: 1));

    final todayPomodoroSessions = sessions.where(
      (session) =>
          session.timerType == TimerType.pomodoro &&
          !session.startedAt.isBefore(startOfDay) &&
          session.startedAt.isBefore(startOfTomorrow),
    );

    var todayFocusSeconds = 0;
    var completedSessions = 0;
    for (final session in todayPomodoroSessions) {
      todayFocusSeconds += session.totalWorkSeconds;
      if (session.pomodoroRoundsCompleted > 0) {
        completedSessions++;
      }
    }

    return _PomodoroScreenData(
      card: card,
      todayFocusSeconds: todayFocusSeconds,
      completedSessions: completedSessions,
    );
  }

  void _startRecovery() {
    final recovery = widget.recovery!;
    final phase = PomodoroPhase.fromString(recovery.pomodoroPhase);
    final completedRounds = (phase == PomodoroPhase.work)
        ? (recovery.pomodoroRound - 1).clamp(0, 999)
        : recovery.pomodoroRound;

    setState(() => _sessionStarted = true);
    context.read<PomodoroCubit>().startSession(
          widget.cardId,
          widget.settings,
          resumeRound: recovery.pomodoroRound,
          resumePhase: phase,
          resumeElapsedSec: 0,
          resumeCompletedRounds: completedRounds,
          resumeTotalBreakSec: recovery.pomodoroTotalBreakSec,
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
            const _TimerBackground(),
            SafeArea(
              child: FutureBuilder<_PomodoroScreenData>(
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

                  return BlocConsumer<PomodoroCubit, PomodoroState>(
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
    _PomodoroScreenData screenData,
    PomodoroState state,
  ) {
    return switch (state) {
      PomodoroInitial() => _buildTimerScreen(
          context,
          screenData,
          display: _PomodoroDisplay.initial(widget.settings),
          showStartOnly: true,
        ),
      PomodoroRunning(
        :final phase,
        :final round,
        :final remainingSeconds,
        :final progress,
        :final completedRounds,
        :final shortBreakInterval,
      ) =>
        _buildTimerScreen(
          context,
          screenData,
          display: _PomodoroDisplay.live(
            phase: phase,
            round: round,
            remainingSeconds: remainingSeconds,
            progress: progress,
            completedRounds: completedRounds,
            shortBreakInterval: shortBreakInterval,
            isPaused: false,
          ),
        ),
      PomodoroPaused(
        :final phase,
        :final round,
        :final remainingSeconds,
        :final progress,
        :final completedRounds,
        :final shortBreakInterval,
      ) =>
        _buildTimerScreen(
          context,
          screenData,
          display: _PomodoroDisplay.live(
            phase: phase,
            round: round,
            remainingSeconds: remainingSeconds,
            progress: progress,
            completedRounds: completedRounds,
            shortBreakInterval: shortBreakInterval,
            isPaused: true,
          ),
        ),
      PomodoroPhaseComplete(:final completedRounds, :final nextPhase) =>
        _buildTimerScreen(
          context,
          screenData,
          display: _PomodoroDisplay.transition(
            phase: nextPhase,
            round: nextPhase == PomodoroPhase.work
                ? completedRounds + 1
                : completedRounds,
            remainingSeconds: _durationForPhase(nextPhase),
            shortBreakInterval: widget.settings.shortBreakInterval,
            completedRounds: completedRounds,
            bannerText: nextPhase == PomodoroPhase.work
                ? 'Break over. Focus session starts now.'
                : 'Round $completedRounds completed. Break starts now.',
          ),
        ),
      PomodoroEnded() => const Center(child: CircularProgressIndicator()),
      PomodoroError(:final message) => Center(child: Text(message)),
    };
  }

  Widget _buildTimerScreen(
    BuildContext context,
    _PomodoroScreenData screenData, {
    required _PomodoroDisplay display,
    bool showStartOnly = false,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final timerSize = math.max(260.0, math.min(width - 72, 360.0));
    final canSwitchMode = !_sessionStarted;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        children: [
          _TopBar(
            onBack: () async {
              final shouldPop = await _confirmExit(context);
              if (shouldPop && context.mounted) {
                context.pop();
              }
            },
          ),
          const SizedBox(height: 18),
          _CardInfoPanel(card: screenData.card),
          const SizedBox(height: 18),
          _ModeSwitch(
            activeMode: _TimerScreenMode.pomodoro,
            onPomodoro: null,
            onDeepWork: canSwitchMode
                ? () => context.pushReplacement(
                      RoutePaths.deepWorkPath(widget.cardId),
                    )
                : null,
          ),
          if (display.bannerText != null) ...[
            const SizedBox(height: 14),
            _BannerChip(text: display.bannerText!),
          ],
          const SizedBox(height: 24),
          CircularCountdown(
            phase: display.phase,
            progress: display.progress,
            remainingSeconds: display.remainingSeconds,
            isRunning: !display.isPaused && !showStartOnly,
            size: timerSize,
          ),
          const SizedBox(height: 24),
          _StatsStrip(
            items: [
              _StatItemData(
                icon: Icons.schedule_rounded,
                iconColor: AppColors.primary,
                label: 'Work',
                value: '${widget.settings.workDurationMinutes} min',
              ),
              _StatItemData(
                icon: Icons.free_breakfast_rounded,
                iconColor: const Color(0xFF4A90E2),
                label: 'Short Break',
                value: '${widget.settings.shortBreakMinutes} min',
              ),
              _StatItemData(
                icon: Icons.autorenew_rounded,
                iconColor: const Color(0xFF27AE60),
                label: 'Round',
                value: '${display.round} / ${display.shortBreakInterval}',
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
          _SummaryPanel(
            todayFocusText:
                _formatReadableDuration(screenData.todayFocusSeconds),
            completedSessions: screenData.completedSessions,
          ),
          const SizedBox(height: 18),
          Text(
            'Stay focused, one session at a time.',
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
    required _PomodoroDisplay display,
    required bool showStartOnly,
  }) {
    final cubit = context.read<PomodoroCubit>();

    if (showStartOnly) {
      return _CenterActionButton(
        icon: Icons.play_arrow_rounded,
        onTap: () {
          setState(() => _sessionStarted = true);
          cubit.startSession(widget.cardId, widget.settings);
        },
      );
    }

    final isBreak = display.phase == PomodoroPhase.shortBreak ||
        display.phase == PomodoroPhase.longBreak;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _SideActionButton(
              icon: Icons.restart_alt_rounded,
              iconColor: AppColors.primary,
              onTap: () => _restartSession(context),
            ),
            _CenterActionButton(
              icon: display.isPaused
                  ? Icons.play_arrow_rounded
                  : Icons.pause_rounded,
              onTap: display.isPaused ? cubit.resume : cubit.pause,
            ),
            _SideActionButton(
              icon: Icons.stop_rounded,
              iconColor: AppColors.primary,
              onTap: () => _handleEnd(context),
            ),
          ],
        ),
        if (isBreak) ...[
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: cubit.skipBreak,
            icon: const Icon(Icons.skip_next_rounded, size: 18),
            label: const Text('Skip Break'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  int _durationForPhase(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.work:
        return widget.settings.workDurationSeconds;
      case PomodoroPhase.shortBreak:
        return widget.settings.shortBreakSeconds;
      case PomodoroPhase.longBreak:
        return widget.settings.longBreakSeconds;
    }
  }

  Future<bool> _confirmExit(BuildContext context) async {
    if (!_sessionStarted) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('End session?'),
        content: const Text(
          'Your Pomodoro session is in progress. End it and save progress?',
        ),
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
        content: const Text('This will reset the current Pomodoro progress.'),
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
          .read<PomodoroCubit>()
          .startSession(widget.cardId, widget.settings);
    }
  }

  Future<void> _handleEnd(BuildContext context) async {
    final confirmed = await _confirmExit(context);
    if (confirmed && context.mounted) {
      context.read<PomodoroCubit>().endSession();
    }
  }

  void _showCompletionAndPop(BuildContext context, PomodoroEnded state) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              size: 52,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Session saved',
              style: AppTextStyles.bodyBold.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              '${state.roundsCompleted} rounds • ${_formatReadableDuration(state.totalWorkSeconds)} focused',
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

class _PomodoroScreenData {
  const _PomodoroScreenData({
    required this.card,
    required this.todayFocusSeconds,
    required this.completedSessions,
  });

  final StrangeCard card;
  final int todayFocusSeconds;
  final int completedSessions;
}

class _PomodoroDisplay {
  const _PomodoroDisplay({
    required this.phase,
    required this.round,
    required this.remainingSeconds,
    required this.progress,
    required this.completedRounds,
    required this.shortBreakInterval,
    required this.isPaused,
    this.bannerText,
  });

  factory _PomodoroDisplay.initial(PomodoroSettings settings) {
    return _PomodoroDisplay(
      phase: PomodoroPhase.work,
      round: 1,
      remainingSeconds: settings.workDurationSeconds,
      progress: 0,
      completedRounds: 0,
      shortBreakInterval: settings.shortBreakInterval,
      isPaused: false,
    );
  }

  factory _PomodoroDisplay.live({
    required PomodoroPhase phase,
    required int round,
    required int remainingSeconds,
    required double progress,
    required int completedRounds,
    required int shortBreakInterval,
    required bool isPaused,
  }) {
    return _PomodoroDisplay(
      phase: phase,
      round: round,
      remainingSeconds: remainingSeconds,
      progress: progress,
      completedRounds: completedRounds,
      shortBreakInterval: shortBreakInterval,
      isPaused: isPaused,
    );
  }

  factory _PomodoroDisplay.transition({
    required PomodoroPhase phase,
    required int round,
    required int remainingSeconds,
    required int completedRounds,
    required int shortBreakInterval,
    required String bannerText,
  }) {
    return _PomodoroDisplay(
      phase: phase,
      round: round,
      remainingSeconds: remainingSeconds,
      progress: 0,
      completedRounds: completedRounds,
      shortBreakInterval: shortBreakInterval,
      isPaused: false,
      bannerText: bannerText,
    );
  }

  final PomodoroPhase phase;
  final int round;
  final int remainingSeconds;
  final double progress;
  final int completedRounds;
  final int shortBreakInterval;
  final bool isPaused;
  final String? bannerText;
}

class _TimerBackground extends StatelessWidget {
  const _TimerBackground();

  @override
  Widget build(BuildContext context) {
    final surface =
        context.isDark ? AppColors.darkSurfaceBase : AppColors.surfaceBase;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: surface,
        gradient: const RadialGradient(
          center: Alignment(0, -0.15),
          radius: 1.05,
          colors: [
            Colors.white,
            AppColors.surfaceElevated,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 110,
            left: -40,
            child: _GlowOrb(
              diameter: 180,
              color: AppColors.primary.withValues(alpha: 0.05),
            ),
          ),
          Positioned(
            top: 320,
            right: -40,
            child: _GlowOrb(
              diameter: 150,
              color: const Color(0xFF4A90E2).withValues(alpha: 0.05),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 40,
            child: _GlowOrb(
              diameter: 120,
              color: const Color(0xFF27AE60).withValues(alpha: 0.04),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HeaderButton(
          icon: Icons.arrow_back_rounded,
          iconColor: AppColors.primary,
          onTap: onBack,
        ),
        const Spacer(),
        Text(
          'Strange',
          style: AppTextStyles.appTitle.copyWith(fontSize: 34),
        ),
        const Spacer(),
        const SizedBox(width: 56),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: context.clayRaised(radius: 18),
        child: Icon(icon, color: iconColor, size: 28),
      ),
    );
  }
}

class _CardInfoPanel extends StatelessWidget {
  const _CardInfoPanel({required this.card});

  final StrangeCard card;

  @override
  Widget build(BuildContext context) {
    final cardColor = _colorFromHex(card.colorHex);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: context.clayRaised(radius: 30),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cardColor,
                  cardColor.withValues(alpha: 0.82),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: cardColor.withValues(alpha: 0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              _iconForType(card.type),
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.name,
                  style: AppTextStyles.heading.copyWith(fontSize: 18),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  card.type.displayName,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.more_vert_rounded,
            color: AppColors.primary.withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }

  static IconData _iconForType(CardType type) {
    switch (type) {
      case CardType.learning:
        return Icons.chat_bubble_rounded;
      case CardType.project:
        return Icons.work_rounded;
      case CardType.habit:
        return Icons.favorite_rounded;
    }
  }

  static Color _colorFromHex(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.primary;
    }
  }
}

enum _TimerScreenMode { pomodoro, deepWork }

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({
    required this.activeMode,
    this.onPomodoro,
    this.onDeepWork,
  });

  final _TimerScreenMode activeMode;
  final VoidCallback? onPomodoro;
  final VoidCallback? onDeepWork;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      decoration: context.clayRaised(radius: 26),
      child: Row(
        children: [
          Expanded(
            child: _ModeTab(
              label: 'Pomodoro',
              isActive: activeMode == _TimerScreenMode.pomodoro,
              onTap: onPomodoro,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ModeTab(
              label: 'Deep Work',
              isActive: activeMode == _TimerScreenMode.deepWork,
              onTap: onDeepWork,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.label,
    required this.isActive,
    this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = isActive ? Colors.white : AppColors.textOnSurface;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: isActive
            ? BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(22),
              ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyBold.copyWith(
            color: textColor.withValues(
                alpha: onTap == null && !isActive ? 0.45 : 1),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _BannerChip extends StatelessWidget {
  const _BannerChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({required this.items});

  final List<_StatItemData> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: context.clayRaised(radius: 30),
      child: Row(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            Expanded(child: _StatItem(item: items[index])),
            if (index != items.length - 1)
              Container(
                width: 1,
                height: 58,
                color: AppColors.surfaceMuted,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
          ],
        ],
      ),
    );
  }
}

class _StatItemData {
  const _StatItemData({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.item});

  final _StatItemData item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.iconColor.withValues(alpha: 0.1),
          ),
          child: Icon(item.icon, color: item.iconColor),
        ),
        const SizedBox(height: 10),
        Text(
          item.label,
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          item.value,
          style: AppTextStyles.bodyBold.copyWith(
            color: item.iconColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({
    required this.todayFocusText,
    required this.completedSessions,
  });

  final String todayFocusText;
  final int completedSessions;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: context.clayRaised(radius: 28),
      child: Column(
        children: [
          _SummaryRow(
            icon: Icons.show_chart_rounded,
            iconColor: AppColors.primary,
            label: 'Today focus',
            value: todayFocusText,
            valueColor: AppColors.primary,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _SummaryRow(
            icon: Icons.workspace_premium_rounded,
            iconColor: const Color(0xFF4A90E2),
            label: 'Completed sessions',
            value: '$completedSessions',
            valueColor: const Color(0xFF4A90E2),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: context.clayRaised(radius: 14),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyBold.copyWith(fontSize: 16),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyBold.copyWith(
            fontSize: 18,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _SideActionButton extends StatelessWidget {
  const _SideActionButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 104,
        height: 104,
        decoration: context.clayRaised(radius: 32),
        child: Icon(icon, color: iconColor, size: 42),
      ),
    );
  }
}

class _CenterActionButton extends StatelessWidget {
  const _CenterActionButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 116,
        height: 116,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.24),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
            const BoxShadow(
              color: AppColors.clayHighlight,
              blurRadius: 12,
              offset: Offset(-4, -4),
              spreadRadius: -6,
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 54),
      ),
    );
  }
}
