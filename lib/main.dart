import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/init/theme/app_theme.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_constants.dart';
import 'features/onboarding/view/onboarding_view.dart';

void main() {
  runApp(const MyApp());
}

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    AppColors.isDark = _isDark; // AppColors sınıfındaki isDark değerini güncelle
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: AppConstants.appName,
            theme: themeProvider.isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
            home: const OnboardingView(),
          );
        },
      ),
    );
  }
}
