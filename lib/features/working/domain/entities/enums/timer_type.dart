enum TimerType {
  pomodoro,
  deepWork;

  String get value {
    switch (this) {
      case TimerType.pomodoro:
        return 'pomodoro';
      case TimerType.deepWork:
        return 'deep_work';
    }
  }

  static TimerType fromString(String value) {
    switch (value) {
      case 'deep_work':
        return TimerType.deepWork;
      default:
        return TimerType.pomodoro;
    }
  }
}
