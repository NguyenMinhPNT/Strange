import 'package:flutter/material.dart';

import '../../../../core/widgets/app_drawer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('Settings — Sprint 5')),
    );
  }
}
