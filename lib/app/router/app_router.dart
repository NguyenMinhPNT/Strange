import 'package:go_router/go_router.dart';

import '../../features/home/domain/entities/enums/card_type.dart';
import '../../features/home/presentation/pages/card_form_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/settings/presentation/pages/about_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/stats/presentation/pages/stats_page.dart';
import '../../features/working/presentation/pages/deep_work_page.dart';
import '../../features/working/presentation/pages/pomodoro_page.dart';
import '../../features/working/presentation/pages/working_page.dart';
import 'route_paths.dart';

final appRouter = GoRouter(
  initialLocation: RoutePaths.home,
  routes: [
    GoRoute(
      path: RoutePaths.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: RoutePaths.cardCreate,
      builder: (context, state) {
        final initialType = state.extra as CardType?;
        return CardFormPage(initialType: initialType);
      },
    ),
    GoRoute(
      path: RoutePaths.cardEdit,
      builder: (context, state) {
        final cardId = int.parse(state.pathParameters['cardId']!);
        return CardFormPage(cardId: cardId);
      },
    ),
    GoRoute(
      path: RoutePaths.working,
      builder: (context, state) {
        final cardId = int.parse(state.pathParameters['cardId']!);
        return WorkingPage(cardId: cardId);
      },
    ),
    GoRoute(
      path: RoutePaths.pomodoro,
      builder: (context, state) {
        final cardId = int.parse(state.pathParameters['cardId']!);
        return PomodoroPage(cardId: cardId);
      },
    ),
    GoRoute(
      path: RoutePaths.deepWork,
      builder: (context, state) {
        final cardId = int.parse(state.pathParameters['cardId']!);
        return DeepWorkPage(cardId: cardId);
      },
    ),
    GoRoute(
      path: RoutePaths.stats,
      builder: (context, state) => const StatsPage(),
    ),
    GoRoute(
      path: RoutePaths.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: RoutePaths.about,
      builder: (context, state) => const AboutPage(),
    ),
  ],
);
