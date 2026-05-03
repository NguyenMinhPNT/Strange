import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/theme/app_theme.dart';
import '../features/working/data/datasources/timer_service.dart';
import 'di/injection_container.dart';
import 'router/app_router.dart';

import '../l10n/app_localizations.dart';

class StrangeApp extends StatefulWidget {
  const StrangeApp({super.key});

  @override
  State<StrangeApp> createState() => _StrangeAppState();
}

class _StrangeAppState extends State<StrangeApp> {
  @override
  void initState() {
    super.initState();
    TimerService.initForegroundTask();
    // Request notification permission for foreground task (Android 13+)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getIt<TimerService>().requestPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Strange',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('vi')],
    );
  }
}
