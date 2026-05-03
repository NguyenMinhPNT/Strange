import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection_container.dart';
import '../../../../app/router/route_paths.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/clay_tab_bar.dart';
import '../../../working/data/datasources/timer_preferences.dart';
import '../../../working/domain/entities/timer_recovery_params.dart';
import '../../domain/entities/enums/card_type.dart';
import '../../domain/usecases/get_card_by_id_usecase.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/add_card_fab.dart';
import '../widgets/card_tab_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTabIndex = 0;

  static const List<CardType> _tabs = [
    CardType.learning,
    CardType.project,
    CardType.habit,
  ];

  CardType get _selectedType => _tabs[_selectedTabIndex];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkTimerRecovery());
  }

  Future<void> _checkTimerRecovery() async {
    final prefs = getIt<TimerPreferences>();
    if (!prefs.hasActiveTimer) return;

    final cardId = prefs.timerCardId;
    if (cardId == null) {
      unawaited(prefs.clearTimerState());
      return;
    }

    String cardName = 'your session';
    try {
      final card = await getIt<GetCardByIdUseCase>()(cardId);
      if (card != null) cardName = card.name;
    } catch (_) {}

    if (!mounted) return;

    final shouldResume = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Resume session?'),
        content:
            Text('You have an interrupted "$cardName" session. Resume it?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Discard'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Resume'),
          ),
        ],
      ),
    );

    if (shouldResume != true) {
      unawaited(prefs.clearTimerState());
      return;
    }

    if (!mounted) return;

    final recovery = TimerRecoveryParams(
      timerType: prefs.timerType ?? 'pomodoro',
      elapsedWorkSec: prefs.timerElapsedWorkSec,
      pomodoroRound: prefs.pomodoroCurrentRound,
      pomodoroPhase: prefs.pomodoroCurrentPhase,
      pomodoroTotalBreakSec: prefs.pomodoroTotalBreakSec,
      deepWorkTotalPauseSec: prefs.deepWorkTotalPauseSec,
    );

    if (recovery.timerType == 'pomodoro') {
      context.push(RoutePaths.pomodoroPath(cardId), extra: recovery);
    } else {
      context.push(RoutePaths.deepWorkPath(cardId), extra: recovery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..loadCards(),
      child: Builder(
        builder: (context) {
          return BlocListener<HomeCubit, HomeState>(
            listener: (context, state) {
              if (state is HomeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text('Strange', style: AppTextStyles.appTitle),
                centerTitle: true,
              ),
              drawer: const AppDrawer(),
              body: Column(
                children: [
                  ClayTabBar(
                    tabs: _tabs.map((t) => t.displayName).toList(),
                    selectedIndex: _selectedTabIndex,
                    onTabSelected: (i) => setState(() => _selectedTabIndex = i),
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: _selectedTabIndex,
                      children: _tabs.map((t) => CardTabView(type: t)).toList(),
                    ),
                  ),
                ],
              ),
              floatingActionButton: AddCardFab(selectedType: _selectedType),
            ),
          );
        },
      ),
    );
  }
}
