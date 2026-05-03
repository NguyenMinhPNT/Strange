import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/theme/app_theme.dart';
import '../features/working/data/datasources/timer_service.dart';
import 'router/app_router.dart';

import '../l10n/app_localizations.dart';

class StrangeApp extends StatelessWidget {
  const StrangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    TimerService.initForegroundTask();
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
