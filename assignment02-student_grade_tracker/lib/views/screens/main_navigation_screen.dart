import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/grade_tracker_provider.dart';
import 'add_subject_screen.dart';
import 'subject_list_screen.dart';
import 'summary_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the provider state
    final provider = context.watch<GradeTrackerProvider>();
    final currentIndex = provider.currentIndex;
    final isDark = provider.isDarkMode;

    // Define titles for the screens
    final List<String> titles = [
      'Add Subject',
      'Subject List',
      'Summary Dashboard',
    ];

    // Define the views/screens
    final List<Widget> screens = [
      const AddSubjectScreen(),
      const SubjectListScreen(),
      const SummaryScreen(),
    ];

    // Read colors from theme
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: theme.appBarTheme.iconTheme?.color,
            ),
            onPressed: () {
              provider.toggleTheme();
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: screens[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          provider.setCurrentIndex(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Add Subject',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Summary',
          ),
        ],
      ),
    );
  }
}
