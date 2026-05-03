/// Named route paths for GoRouter.
class RoutePaths {
  RoutePaths._();

  static const String home = '/';
  static const String cardCreate = '/card/create';
  static const String cardEdit = '/card/:cardId/edit';
  static const String working = '/card/:cardId/working';
  static const String pomodoro = '/card/:cardId/pomodoro';
  static const String deepWork = '/card/:cardId/deep-work';
  static const String stats = '/stats';
  static const String settings = '/settings';
  static const String about = '/about';

  /// Build a cardEdit path with the given id.
  static String cardEditPath(int cardId) => '/card/$cardId/edit';

  /// Build a working path with the given id.
  static String workingPath(int cardId) => '/card/$cardId/working';

  /// Build a pomodoro path with the given id.
  static String pomodoroPath(int cardId) => '/card/$cardId/pomodoro';

  /// Build a deepWork path with the given id.
  static String deepWorkPath(int cardId) => '/card/$cardId/deep-work';
}
