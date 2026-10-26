import 'package:flutter/material.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

// Nama: Ni Komang Tri Lindyasari
// NIM : 2415051017

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;
  CourseProvider(this.repository);

  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  final Set<String> _favorites = {};
  Set<String> get favorites => _favorites;

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();
    
    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(String courseCode) {
    if (_favorites.contains(courseCode)) {
      _favorites.remove(courseCode);
    } else {
      _favorites.add(courseCode);
    }
    notifyListeners(); 
  }
}