/// Deep Work timer constants and defaults
class DeepWorkConstants {
  DeepWorkConstants._();

  static const int defaultMaxPauseSeconds = 300; // 5 minutes
  static const int minMaxPauseSeconds = 60; // 1 minute
  static const int maxMaxPauseSeconds = 1800; // 30 minutes

  static const int pauseWarningSeconds = 30; // urgent color change
  static const int pauseVibrateSeconds = 10; // vibrate warning
}
