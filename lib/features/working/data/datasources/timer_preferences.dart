import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// All SharedPreferences keys used by the timer.
abstract class TimerPrefKeys {
  static const String timerStatus = 'timer_status'; // 'running' | 'paused'
  static const String timerCardId = 'timer_active_card_id';
  static const String timerType =
      'timer_active_type'; // 'pomodoro' | 'deep_work'
  static const String timerStartEpoch = 'timer_start_epoch'; // int (ms)
  static const String timerElapsedWorkSec = 'timer_elapsed_work_sec';

  // Pomodoro-specific
  static const String pomodoroCurrentRound = 'pomo_current_round';
  static const String pomodoroCurrentPhase = 'pomo_current_phase';
  static const String pomodoroTotalBreakSec = 'pomo_total_break_sec';

  // Deep Work-specific
  static const String deepWorkTotalPauseSec = 'dw_total_pause_sec';
}

/// Settings pref keys (default values only; Sprint 5 manages full settings).
abstract class SettingsPrefKeys {
  static const String pomodoroWorkMinutes = 'pomo_work_duration';
  static const String pomodoroShortBreakMinutes = 'pomo_short_break';
  static const String pomodoroLongBreakMinutes = 'pomo_long_break';
  static const String pomodoroShortBreakInterval = 'pomo_interval';
  static const String deepWorkMaxPauseSeconds = 'dw_max_pause_seconds';
}

/// Thin wrapper around [SharedPreferences] for timer state persistence.
@lazySingleton
class TimerPreferences {
  TimerPreferences(this._prefs);

  final SharedPreferences _prefs;

  // ---- Write ----

  Future<void> persistTimerStarted({
    required int cardId,
    required String timerType,
    required int startEpochMs,
    required int elapsedWorkSec,
    int pomodoroRound = 1,
    String pomodoroPhase = 'work',
    int pomodoroTotalBreakSec = 0,
    int deepWorkTotalPauseSec = 0,
  }) async {
    await Future.wait([
      _prefs.setString(TimerPrefKeys.timerStatus, 'running'),
      _prefs.setInt(TimerPrefKeys.timerCardId, cardId),
      _prefs.setString(TimerPrefKeys.timerType, timerType),
      _prefs.setInt(TimerPrefKeys.timerStartEpoch, startEpochMs),
      _prefs.setInt(TimerPrefKeys.timerElapsedWorkSec, elapsedWorkSec),
      _prefs.setInt(TimerPrefKeys.pomodoroCurrentRound, pomodoroRound),
      _prefs.setString(TimerPrefKeys.pomodoroCurrentPhase, pomodoroPhase),
      _prefs.setInt(TimerPrefKeys.pomodoroTotalBreakSec, pomodoroTotalBreakSec),
      _prefs.setInt(TimerPrefKeys.deepWorkTotalPauseSec, deepWorkTotalPauseSec),
    ]);
  }

  Future<void> persistTimerPaused({
    required int elapsedWorkSec,
    int pomodoroRound = 1,
    String pomodoroPhase = 'work',
    int pomodoroTotalBreakSec = 0,
    int deepWorkTotalPauseSec = 0,
  }) async {
    await Future.wait([
      _prefs.setString(TimerPrefKeys.timerStatus, 'paused'),
      _prefs.setInt(TimerPrefKeys.timerElapsedWorkSec, elapsedWorkSec),
      _prefs.setInt(TimerPrefKeys.pomodoroCurrentRound, pomodoroRound),
      _prefs.setString(TimerPrefKeys.pomodoroCurrentPhase, pomodoroPhase),
      _prefs.setInt(TimerPrefKeys.pomodoroTotalBreakSec, pomodoroTotalBreakSec),
      _prefs.setInt(TimerPrefKeys.deepWorkTotalPauseSec, deepWorkTotalPauseSec),
    ]);
  }

  Future<void> clearTimerState() async {
    await Future.wait([
      _prefs.remove(TimerPrefKeys.timerStatus),
      _prefs.remove(TimerPrefKeys.timerCardId),
      _prefs.remove(TimerPrefKeys.timerType),
      _prefs.remove(TimerPrefKeys.timerStartEpoch),
      _prefs.remove(TimerPrefKeys.timerElapsedWorkSec),
      _prefs.remove(TimerPrefKeys.pomodoroCurrentRound),
      _prefs.remove(TimerPrefKeys.pomodoroCurrentPhase),
      _prefs.remove(TimerPrefKeys.pomodoroTotalBreakSec),
      _prefs.remove(TimerPrefKeys.deepWorkTotalPauseSec),
    ]);
  }

  // ---- Read ----

  String? get timerStatus => _prefs.getString(TimerPrefKeys.timerStatus);
  int? get timerCardId => _prefs.getInt(TimerPrefKeys.timerCardId);
  String? get timerType => _prefs.getString(TimerPrefKeys.timerType);
  int? get timerStartEpochMs => _prefs.getInt(TimerPrefKeys.timerStartEpoch);
  int get timerElapsedWorkSec =>
      _prefs.getInt(TimerPrefKeys.timerElapsedWorkSec) ?? 0;
  int get pomodoroCurrentRound =>
      _prefs.getInt(TimerPrefKeys.pomodoroCurrentRound) ?? 1;
  String get pomodoroCurrentPhase =>
      _prefs.getString(TimerPrefKeys.pomodoroCurrentPhase) ?? 'work';
  int get pomodoroTotalBreakSec =>
      _prefs.getInt(TimerPrefKeys.pomodoroTotalBreakSec) ?? 0;
  int get deepWorkTotalPauseSec =>
      _prefs.getInt(TimerPrefKeys.deepWorkTotalPauseSec) ?? 0;

  bool get hasActiveTimer => timerStatus != null;

  // ---- Settings (read-only defaults; Sprint 5 writes them) ----

  int get pomodoroWorkMinutes =>
      _prefs.getInt(SettingsPrefKeys.pomodoroWorkMinutes) ?? 25;
  int get pomodoroShortBreakMinutes =>
      _prefs.getInt(SettingsPrefKeys.pomodoroShortBreakMinutes) ?? 5;
  int get pomodoroLongBreakMinutes =>
      _prefs.getInt(SettingsPrefKeys.pomodoroLongBreakMinutes) ?? 15;
  int get pomodoroShortBreakInterval =>
      _prefs.getInt(SettingsPrefKeys.pomodoroShortBreakInterval) ?? 4;
  int get deepWorkMaxPauseSeconds =>
      _prefs.getInt(SettingsPrefKeys.deepWorkMaxPauseSeconds) ?? 300;
}
