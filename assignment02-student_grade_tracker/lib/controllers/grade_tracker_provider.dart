import 'package:flutter/material.dart';
import '../models/subject.dart';

class GradeTrackerProvider with ChangeNotifier {
  // Subjects list
  final List<Subject> _subjects = [];

  // Active navigation tab index (Add: 0, List: 1, Summary: 2)
  int _currentIndex = 0;

  // Active theme mode
  ThemeMode _themeMode = ThemeMode.light;

  // Getters
  List<Subject> get subjects => List.unmodifiable(_subjects);
  int get currentIndex => _currentIndex;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Tab navigation controller
  void setCurrentIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  // Theme toggle controller
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Subject operations
  void addSubject(String name, double mark) {
    _subjects.add(Subject(name, mark));
    notifyListeners();
  }

  void deleteSubject(int index) {
    if (index >= 0 && index < _subjects.length) {
      _subjects.removeAt(index);
      notifyListeners();
    }
  }

  // Computed statistics (using map/where)
  int get totalSubjects => _subjects.length;

  /// Uses `.where()` to filter passing subjects (Grade is not 'F')
  int get passingSubjectsCount {
    return _subjects.where((subject) => subject.grade != 'F').length;
  }

  /// Uses `.where()` to filter failing subjects (Grade is 'F')
  int get failingSubjectsCount {
    return _subjects.where((subject) => subject.grade == 'F').length;
  }

  /// Uses `.map()` and `.fold()` to calculate the average mark
  double get averageMark {
    if (_subjects.isEmpty) return 0.0;
    final totalMarks = _subjects.map((s) => s.mark).fold(0.0, (sum, mark) => sum + mark);
    return totalMarks / _subjects.length;
  }

  /// Calculates overall grade based on the average mark
  String get overallGrade {
    final avg = averageMark;
    if (avg >= 80) {
      return 'A';
    } else if (avg >= 65) {
      return 'B';
    } else if (avg >= 50) {
      return 'C';
    } else {
      return 'F';
    }
  }
}
