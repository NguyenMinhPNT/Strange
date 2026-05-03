import 'package:flutter/material.dart';

import '../../../../core/widgets/app_drawer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('About - Sprint 5')),
    );
  }
}
