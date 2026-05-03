/// Carries persisted timer state for crash/kill recovery.
///
/// Passed as [GoRouter] `extra` when navigating directly to a timer page
/// after the user confirms they want to resume an interrupted session.
class TimerRecoveryParams {
  const TimerRecoveryParams({
    required this.timerType,
    required this.elapsedWorkSec,
    this.pomodoroRound = 1,
    this.pomodoroPhase = 'work',
    this.pomodoroTotalBreakSec = 0,
    this.deepWorkTotalPauseSec = 0,
  });

  /// 'pomodoro' or 'deep_work'
  final String timerType;

  /// Total work seconds accumulated before the crash.
  final int elapsedWorkSec;

  // ---- Pomodoro-specific ----

  /// Round number that was in progress (1-based).
  final int pomodoroRound;

  /// Phase value: 'work' | 'short_break' | 'long_break'
  final String pomodoroPhase;

  /// Total break seconds accumulated before the crash.
  final int pomodoroTotalBreakSec;

  // ---- Deep Work-specific ----

  /// Total pause seconds accumulated before the crash.
  final int deepWorkTotalPauseSec;
}
