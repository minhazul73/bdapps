import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/grade_tracker_provider.dart';
import 'views/screens/main_navigation_screen.dart';
import 'views/themes/app_themes.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GradeTrackerProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GradeTrackerProvider>();

    return MaterialApp(
      title: 'Student Grade Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: provider.themeMode,
      home: const MainNavigationScreen(),
    );
  }
}