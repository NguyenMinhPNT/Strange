import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../data/datasources/timer_preferences.dart';
import '../../data/datasources/timer_service.dart';
import '../../domain/entities/enums/pomodoro_phase.dart';
import '../../domain/entities/enums/session_status.dart';
import '../../domain/entities/enums/timer_type.dart';
import '../../domain/usecases/save_session_usecase.dart';
import '../../../settings/domain/entities/pomodoro_settings.dart';
import 'pomodoro_state.dart';

@injectable
class PomodoroCubit extends Cubit<PomodoroState> {
  PomodoroCubit(
    this._timerService,
    this._timerPrefs,
    this._saveSession,
  ) : super(PomodoroInitial());

  final TimerService _timerService;
  final TimerPreferences _timerPrefs;
  final SaveSessionUseCase _saveSession;

  StreamSubscription<int>? _tickSub;

  late int _cardId;
  late PomodoroSettings _settings;
  late DateTime _startedAt;

  PomodoroPhase _phase = PomodoroPhase.work;
  int _currentRound = 1;
  int _completedRounds = 0;
  int _elapsedSecondsInPhase = 0;
  int _totalWorkSeconds = 0;
  int _totalBreakSeconds = 0;
  bool _isPaused = false;

  int get _targetSeconds {
    switch (_phase) {
      case PomodoroPhase.work:
        return _settings.workDurationSeconds;
      case PomodoroPhase.shortBreak:
        return _settings.shortBreakSeconds;
      case PomodoroPhase.longBreak:
        return _settings.longBreakSeconds;
    }
  }

  void startSession(
    int cardId,
    PomodoroSettings settings, {
    int resumeRound = 1,
    PomodoroPhase resumePhase = PomodoroPhase.work,
    int resumeElapsedSec = 0,
    int resumeCompletedRounds = 0,
    int resumeTotalBreakSec = 0,
  }) {
    _cardId = cardId;
    _settings = settings;
    _startedAt = DateTime.now();
    _phase = resumePhase;
    _currentRound = resumeRound;
    _completedRounds = resumeCompletedRounds;
    _elapsedSecondsInPhase = resumeElapsedSec;
    _totalWorkSeconds = 0;
    _totalBreakSeconds = resumeTotalBreakSec;
    _isPaused = false;

    _persistRunningState();
    _startTicking();
    _emitRunning();
  }

  void pause() {
    if (_isPaused) return;
    _isPaused = true;
    _timerService.stopTicker();
    _tickSub?.cancel();

    _persistPausedState();
    _timerService.updateNotification(
      '🍅 Pomodoro — Paused',
      'Round $_currentRound • ${_phase.displayLabel}',
    );

    emit(PomodoroPaused(
      phase: _phase,
      round: _currentRound,
      remainingSeconds: _targetSeconds - _elapsedSecondsInPhase,
      progress: _elapsedSecondsInPhase / _targetSeconds,
      completedRounds: _completedRounds,
      shortBreakInterval: _settings.shortBreakInterval,
    ));
  }

  void resume() {
    if (!_isPaused) return;
    _isPaused = false;
    _persistRunningState();
    _startTicking();
    _emitRunning();
  }

  void skipBreak() {
    if (_phase == PomodoroPhase.work) return;
    _phase = PomodoroPhase.work;
    _elapsedSecondsInPhase = 0;
    _isPaused = false;
    _persistRunningState();
    _startTicking();
    _emitRunning();
  }

  Future<void> endSession() async {
    _timerService.stopTicker();
    _tickSub?.cancel();
    await _timerPrefs.clearTimerState();
    await _timerService.stopForegroundTask();
    await _doSaveSession(SessionStatus.abandoned);
  }

  void _startTicking() {
    _tickSub?.cancel();
    _timerService.startTicker();
    _tickSub = _timerService.tickStream.listen((_) => _onTick());
  }

  void _onTick() {
    _elapsedSecondsInPhase++;

    if (_phase == PomodoroPhase.work) {
      _totalWorkSeconds++;
    } else {
      _totalBreakSeconds++;
    }

    if (_elapsedSecondsInPhase >= _targetSeconds) {
      _onPhaseComplete();
      return;
    }

    _updateNotification();
    _persistRunningState();
    _emitRunning();
  }

  void _onPhaseComplete() {
    _timerService.stopTicker();
    _tickSub?.cancel();

    if (_phase == PomodoroPhase.work) {
      _completedRounds++;
      if (_completedRounds % _settings.shortBreakInterval == 0) {
        _phase = PomodoroPhase.longBreak;
      } else {
        _phase = PomodoroPhase.shortBreak;
      }
    } else {
      _phase = PomodoroPhase.work;
      _currentRound = _completedRounds + 1;
    }

    _elapsedSecondsInPhase = 0;

    emit(PomodoroPhaseComplete(
      completedRounds: _completedRounds,
      nextPhase: _phase,
    ));

    // Auto-transition after delay
    Future.delayed(
      const Duration(milliseconds: AppConstants.phaseCompleteTransitionMs),
      () {
        if (isClosed) return;
        _persistRunningState();
        _startTicking();
        _emitRunning();
      },
    );
  }

  Future<void> _doSaveSession(SessionStatus status) async {
    try {
      final session = await _saveSession(SaveSessionParams(
        cardId: _cardId,
        timerType: TimerType.pomodoro,
        status: status,
        startedAt: _startedAt,
        endedAt: DateTime.now(),
        totalWorkSeconds: _totalWorkSeconds,
        totalBreakSeconds: _totalBreakSeconds,
        pomodoroRoundsCompleted: _completedRounds,
      ));
      emit(PomodoroEnded(
        totalWorkSeconds: _totalWorkSeconds,
        roundsCompleted: _completedRounds,
        savedSession: session,
      ));
    } catch (e) {
      emit(PomodoroError(e.toString()));
    }
  }

  void _emitRunning() {
    final remaining = _targetSeconds - _elapsedSecondsInPhase;
    final progress =
        _targetSeconds > 0 ? _elapsedSecondsInPhase / _targetSeconds : 0.0;
    emit(PomodoroRunning(
      phase: _phase,
      round: _currentRound,
      elapsedSeconds: _elapsedSecondsInPhase,
      remainingSeconds: remaining.clamp(0, _targetSeconds),
      progress: progress.clamp(0.0, 1.0),
      completedRounds: _completedRounds,
      shortBreakInterval: _settings.shortBreakInterval,
    ));
  }

  void _persistRunningState() {
    _timerPrefs.persistTimerStarted(
      cardId: _cardId,
      timerType: TimerType.pomodoro.value,
      startEpochMs: _startedAt.millisecondsSinceEpoch,
      elapsedWorkSec: _totalWorkSeconds,
      pomodoroRound: _currentRound,
      pomodoroPhase: _phase.value,
      pomodoroTotalBreakSec: _totalBreakSeconds,
    );
  }

  void _persistPausedState() {
    _timerPrefs.persistTimerPaused(
      elapsedWorkSec: _totalWorkSeconds,
      pomodoroRound: _currentRound,
      pomodoroPhase: _phase.value,
      pomodoroTotalBreakSec: _totalBreakSeconds,
    );
  }

  void _updateNotification() {
    final remaining = _targetSeconds - _elapsedSecondsInPhase;
    final timeStr = TimerService.formatMmSs(remaining);
    _timerService.updateNotification(
      '🍅 ${_phase.displayLabel} — $timeStr remaining',
      'Round $_currentRound of ${_settings.shortBreakInterval}',
    );
  }

  @override
  Future<void> close() {
    _tickSub?.cancel();
    _timerService.stopTicker();
    return super.close();
  }
}
