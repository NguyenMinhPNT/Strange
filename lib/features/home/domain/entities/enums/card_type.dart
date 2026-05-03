enum CardType {
  learning,
  project,
  habit;

  String get value {
    switch (this) {
      case CardType.learning:
        return 'learning';
      case CardType.project:
        return 'project';
      case CardType.habit:
        return 'habit';
    }
  }

  static CardType fromString(String value) {
    switch (value) {
      case 'project':
        return CardType.project;
      case 'habit':
        return CardType.habit;
      default:
        return CardType.learning;
    }
  }

  String get displayName {
    switch (this) {
      case CardType.learning:
        return 'Learning';
      case CardType.project:
        return 'Projects';
      case CardType.habit:
        return 'Habits';
    }
  }
}
