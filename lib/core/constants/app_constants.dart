/// App-wide constants
class AppConstants {
  AppConstants._();

  // Card
  static const int cardMaxNameLength = 40;
  static const int cardReorderBatchSize = 50;

  // Archive undo
  static const int archiveUndoDurationSeconds = 4;

  // Phase transition delay (ms)
  static const int phaseCompleteTransitionMs = 1500;

  // Timer recovery dialog delay (ms)
  static const int timerRecoveryDialogShowMs = 1500;

  // Stats heatmap intensity thresholds (seconds)
  static const int heatmapLevel1Seconds = 900; // 15 min
  static const int heatmapLevel2Seconds = 1800; // 30 min
  static const int heatmapLevel3Seconds = 3600; // 1 hour
  static const int heatmapLevel4Seconds = 7200; // 2 hours
}
