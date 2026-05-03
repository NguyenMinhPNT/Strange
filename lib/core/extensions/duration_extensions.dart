extension DurationExtensions on Duration {
  String formatMMSS() {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String formatHHMMSS() {
    final hours = inHours.toString().padLeft(2, '0');
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String formatReadable() {
    if (inHours > 0) {
      final h = inHours;
      final m = inMinutes.remainder(60);
      return m > 0 ? '${h}h ${m}m' : '${h}h';
    }
    if (inMinutes > 0) {
      final m = inMinutes;
      final s = inSeconds.remainder(60);
      return s > 0 ? '${m}m ${s}s' : '${m}m';
    }
    return '${inSeconds}s';
  }
}

extension IntDurationExtensions on int {
  Duration get seconds => Duration(seconds: this);
  Duration get minutes => Duration(minutes: this);
  Duration get hours => Duration(hours: this);

  String toMMSS() => Duration(seconds: this).formatMMSS();
  String toHHMMSS() => Duration(seconds: this).formatHHMMSS();
}
