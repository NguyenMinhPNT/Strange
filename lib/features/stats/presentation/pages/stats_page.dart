import 'package:flutter/material.dart';

import '../../../../core/widgets/app_drawer.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('Stats — Sprint 4')),
    );
  }
}
