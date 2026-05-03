/// Pomodoro timer constants and defaults
class PomodoroConstants {
  PomodoroConstants._();

  static const int defaultWorkMinutes = 25;
  static const int defaultShortBreakMinutes = 5;
  static const int defaultLongBreakMinutes = 15;
  static const int defaultShortBreakInterval = 4; // rounds before long break

  static const int minWorkMinutes = 5;
  static const int maxWorkMinutes = 90;
  static const int minShortBreakMinutes = 1;
  static const int maxShortBreakMinutes = 30;
  static const int minLongBreakMinutes = 5;
  static const int maxLongBreakMinutes = 60;
  static const int minShortBreakInterval = 1;
  static const int maxShortBreakInterval = 10;
}
