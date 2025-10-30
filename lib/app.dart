import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:minha_academia_front/main.dart';
import 'package:minha_academia_front/config/router.dart';
import 'package:minha_academia_front/data/repositories/auth_repository.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Consumer<AuthRepository>(
      builder: (context, authRepository, child) {
        final router = buildAppRouter(authRepository);

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'FitClub Admin',

          theme: themeProvider.themeData,

          supportedLocales: const [Locale('pt', 'BR')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          routerConfig: router,
        );
      },
    );
  }
}
