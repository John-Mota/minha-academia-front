import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minha_academia_front/presentation/core/themes/themes.dart';
import 'package:minha_academia_front/data/repositories/auth_repository.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthRepository()),
      ],
      child: const App(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = darkTheme;

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    if (_themeData == lightTheme) {
      _themeData = darkTheme;
    } else {
      _themeData = lightTheme;
    }
    notifyListeners();
  }
}
