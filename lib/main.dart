import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const StrangeApp());
}
