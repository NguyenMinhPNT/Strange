import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection_container.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/clay_tab_bar.dart';
import '../../domain/entities/enums/card_type.dart';
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
