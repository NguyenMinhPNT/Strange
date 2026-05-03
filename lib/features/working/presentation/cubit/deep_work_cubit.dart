import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasources/timer_preferences.dart';
import '../../data/datasources/timer_service.dart';
import '../../domain/entities/enums/session_status.dart';
import '../../domain/entities/enums/timer_type.dart';
import '../../domain/usecases/save_session_usecase.dart';
import '../../../settings/domain/entities/deep_work_settings.dart';
import 'deep_work_state.dart';

@injectable
class DeepWorkCubit extends Cubit<DeepWorkState> {
  DeepWorkCubit(
    this._timerService,
    this._timerPrefs,
    this._saveSession,
  ) : super(DeepWorkInitial());

  final TimerService _timerService;
  final TimerPreferences _timerPrefs;
  final SaveSessionUseCase _saveSession;

  StreamSubscription<int>? _tickSub;

  late int _cardId;
  late DeepWorkSettings _settings;
  late DateTime _startedAt;

  int _elapsedWorkSeconds = 0;
  int _pauseElapsedSeconds = 0;
  int _totalPauseSeconds = 0;
  bool _isPaused = false;

  void startSession(
    int cardId,
    DeepWorkSettings settings, {
    int resumeElapsedWorkSec = 0,
    int resumeTotalPauseSec = 0,
  }) {
    _cardId = cardId;
    _settings = settings;
    _startedAt = DateTime.now();
    _elapsedWorkSeconds = resumeElapsedWorkSec;
    _pauseElapsedSeconds = 0;
    _totalPauseSeconds = resumeTotalPauseSec;
    _isPaused = false;

    _persistRunningState();
    _startTicking();
    _emitRunning();
  }

  void pause() {
    if (_isPaused) return;
    _isPaused = true;
    _pauseElapsedSeconds = 0;
    _timerService.stopTicker();
    _tickSub?.cancel();

    _persistPausedState();
    _startPauseTicking();

    _timerService.updateNotification(
      '🧠 Deep Work — Paused',
      '${TimerService.formatHhMmSs(_elapsedWorkSeconds)} focused',
    );
    _emitPaused();
  }

  void resume() {
    if (!_isPaused) return;
    _isPaused = false;
    _timerService.stopTicker();
    _tickSub?.cancel();

    _persistRunningState();
    _startTicking();
    _emitRunning();
  }

  Future<void> endSession() async {
    _timerService.stopTicker();
    _tickSub?.cancel();
    await _timerPrefs.clearTimerState();
    await _timerService.stopForegroundTask();
    await _doSaveSession(SessionStatus.completed);
  }

  void _startTicking() {
    _tickSub?.cancel();
    _timerService.startTicker();
    _tickSub = _timerService.tickStream.listen((_) => _onWorkTick());
  }

  void _startPauseTicking() {
    _tickSub?.cancel();
    _timerService.startTicker();
    _tickSub = _timerService.tickStream.listen((_) => _onPauseTick());
  }

  void _onWorkTick() {
    _elapsedWorkSeconds++;

    final timeStr = TimerService.formatHhMmSs(_elapsedWorkSeconds);
    _timerService.updateNotification(
      '🧠 Deep Work — $timeStr focused',
      'Tap to return',
    );
    _persistRunningState();
    _emitRunning();
  }

  void _onPauseTick() {
    _pauseElapsedSeconds++;
    _totalPauseSeconds++;

    if (_pauseElapsedSeconds >= _settings.maxPauseSeconds) {
      _timerService.stopTicker();
      _tickSub?.cancel();
      _timerPrefs.clearTimerState();
      _timerService.stopForegroundTask();
      _doSaveSessionAutoEnd();
      return;
    }

    _persistPausedState();
    _emitPaused();
  }

  Future<void> _doSaveSessionAutoEnd() async {
    try {
      final session = await _saveSession(SaveSessionParams(
        cardId: _cardId,
        timerType: TimerType.deepWork,
        status: SessionStatus.abandoned,
        startedAt: _startedAt,
        endedAt: DateTime.now(),
        totalWorkSeconds: _elapsedWorkSeconds,
        deepWorkPauseSeconds: _totalPauseSeconds,
      ));
      emit(DeepWorkAutoEnded(
        totalWorkSeconds: _elapsedWorkSeconds,
        savedSession: session,
      ));
    } catch (e) {
      emit(DeepWorkError(e.toString()));
    }
  }

  Future<void> _doSaveSession(SessionStatus status) async {
    try {
      final session = await _saveSession(SaveSessionParams(
        cardId: _cardId,
        timerType: TimerType.deepWork,
        status: status,
        startedAt: _startedAt,
        endedAt: DateTime.now(),
        totalWorkSeconds: _elapsedWorkSeconds,
        deepWorkPauseSeconds: _totalPauseSeconds,
      ));
      emit(DeepWorkEnded(
        totalWorkSeconds: _elapsedWorkSeconds,
        totalPauseSeconds: _totalPauseSeconds,
        savedSession: session,
      ));
    } catch (e) {
      emit(DeepWorkError(e.toString()));
    }
  }

  void _emitRunning() {
    emit(DeepWorkRunning(
      elapsedWorkSeconds: _elapsedWorkSeconds,
      totalPauseSeconds: _totalPauseSeconds,
    ));
  }

  void _emitPaused() {
    final remaining = _settings.maxPauseSeconds - _pauseElapsedSeconds;
    emit(DeepWorkPaused(
      elapsedWorkSeconds: _elapsedWorkSeconds,
      pauseElapsedSeconds: _pauseElapsedSeconds,
      maxPauseSeconds: _settings.maxPauseSeconds,
      remainingPauseSeconds: remaining.clamp(0, _settings.maxPauseSeconds),
    ));
  }

  void _persistRunningState() {
    _timerPrefs.persistTimerStarted(
      cardId: _cardId,
      timerType: TimerType.deepWork.value,
      startEpochMs: _startedAt.millisecondsSinceEpoch,
      elapsedWorkSec: _elapsedWorkSeconds,
      deepWorkTotalPauseSec: _totalPauseSeconds,
    );
  }

  void _persistPausedState() {
    _timerPrefs.persistTimerPaused(
      elapsedWorkSec: _elapsedWorkSeconds,
      deepWorkTotalPauseSec: _totalPauseSeconds,
    );
  }

  @override
  Future<void> close() {
    _tickSub?.cancel();
    _timerService.stopTicker();
    return super.close();
  }
}
