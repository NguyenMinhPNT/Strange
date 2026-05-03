enum SessionStatus {
  completed,
  abandoned;

  String get value {
    switch (this) {
      case SessionStatus.completed:
        return 'completed';
      case SessionStatus.abandoned:
        return 'abandoned';
    }
  }

  static SessionStatus fromString(String value) {
    switch (value) {
      case 'abandoned':
        return SessionStatus.abandoned;
      default:
        return SessionStatus.completed;
    }
  }
}
