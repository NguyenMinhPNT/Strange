enum CardStatus {
  active,
  archived;

  String get value {
    switch (this) {
      case CardStatus.active:
        return 'active';
      case CardStatus.archived:
        return 'archived';
    }
  }

  static CardStatus fromString(String value) {
    switch (value) {
      case 'archived':
        return CardStatus.archived;
      default:
        return CardStatus.active;
    }
  }
}
