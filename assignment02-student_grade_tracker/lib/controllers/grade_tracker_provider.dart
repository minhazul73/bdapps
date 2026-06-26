import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subject.dart';

class GradeTrackerProvider with ChangeNotifier {
  // Subjects list
  List<Subject> _subjects = [];

  // Active navigation tab index (Add: 0, List: 1, Summary: 2)
  int _currentIndex = 0;

  // Active theme mode
  ThemeMode _themeMode = ThemeMode.light;

  GradeTrackerProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load theme
    final isDark = prefs.getBool('isDarkMode');
    if (isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }

    // Load subjects
    final subjectsJson = prefs.getString('subjects');
    if (subjectsJson != null) {
      final List<dynamic> decodedList = jsonDecode(subjectsJson);
      _subjects = decodedList.map((item) => Subject.fromJson(item as Map<String, dynamic>)).toList();
    }
    
    notifyListeners();
  }

  Future<void> _saveSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(_subjects.map((s) => s.toJson()).toList());
    await prefs.setString('subjects', encodedList);
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

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
    _saveTheme();
    notifyListeners();
  }

  // Subject operations
  void addSubject(String name, double mark) {
    _subjects.add(Subject(name, mark));
    _saveSubjects();
    notifyListeners();
  }

  void deleteSubject(int index) {
    if (index >= 0 && index < _subjects.length) {
      _subjects.removeAt(index);
      _saveSubjects();
      notifyListeners();
    }
  }

  void insertSubject(int index, Subject subject) {
    if (index >= 0 && index <= _subjects.length) {
      _subjects.insert(index, subject);
      _saveSubjects();
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
