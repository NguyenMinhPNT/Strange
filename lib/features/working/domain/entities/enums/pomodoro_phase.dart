enum PomodoroPhase {
  work,
  shortBreak,
  longBreak;

  String get value {
    switch (this) {
      case PomodoroPhase.work:
        return 'work';
      case PomodoroPhase.shortBreak:
        return 'short_break';
      case PomodoroPhase.longBreak:
        return 'long_break';
    }
  }

  static PomodoroPhase fromString(String value) {
    switch (value) {
      case 'short_break':
        return PomodoroPhase.shortBreak;
      case 'long_break':
        return PomodoroPhase.longBreak;
      default:
        return PomodoroPhase.work;
    }
  }

  String get displayLabel {
    switch (this) {
      case PomodoroPhase.work:
        return 'FOCUS';
      case PomodoroPhase.shortBreak:
        return 'SHORT BREAK';
      case PomodoroPhase.longBreak:
        return 'LONG BREAK';
    }
  }
}
