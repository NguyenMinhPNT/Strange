import 'dart:async';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:injectable/injectable.dart';

import 'timer_preferences.dart';

/// Handles the 1-second tick stream and foreground task notification.
/// The cubits own the business logic; this service manages the raw ticker
/// and notification updates.
@lazySingleton
class TimerService {
  TimerService(TimerPreferences prefs);

  StreamController<int>? _tickController;
  Timer? _ticker;
  int _tickCount = 0;

  /// Broadcasts tick count (seconds since start).
  Stream<int> get tickStream => _tickController?.stream ?? const Stream.empty();

  bool get isRunning => _ticker != null && (_ticker?.isActive ?? false);

  // ---- Lifecycle ----

  void startTicker() {
    _stopTicker();
    _tickCount = 0;
    _tickController = StreamController<int>.broadcast();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _tickCount++;
      _tickController?.add(_tickCount);
    });
  }

  void stopTicker() {
    _stopTicker();
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
    _tickController?.close();
    _tickController = null;
  }

  // ---- Foreground Task / Notification ----

  static void initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'strange_timer',
        channelName: 'Strange Timer',
        channelDescription: 'Shows timer progress while session is active.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(1000),
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );
  }

  Future<void> startForegroundTask(
      String notificationTitle, String notificationText) async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.updateService(
        notificationTitle: notificationTitle,
        notificationText: notificationText,
      );
    } else {
      await FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: notificationTitle,
        notificationText: notificationText,
      );
    }
  }

  Future<void> updateNotification(String title, String text) async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.updateService(
        notificationTitle: title,
        notificationText: text,
      );
    }
  }

  Future<void> stopForegroundTask() async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.stopService();
    }
  }

  // ---- Permissions ----

  Future<void> requestPermissions() async {
    await FlutterForegroundTask.requestNotificationPermission();
  }

  // ---- Time formatting helpers ----

  static String formatMmSs(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  static String formatHhMmSs(int totalSeconds) {
    final h = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @disposeMethod
  void dispose() {
    _stopTicker();
  }
}
