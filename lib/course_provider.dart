import 'package:flutter/material.dart';
import 'models/course.dart';
import 'repositories/course_repository.dart';

// Identitas Mahasiswa:
// Nama: Ni Komang Tri Lindyasari
// NIM : 2415051017

class CourseProvider extends ChangeNotifier {
  // 1. Tambahkan repository sebagai dependency
  final CourseRepository repository;

  CourseProvider(this.repository);

  // State untuk Async Data
  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  // State untuk Favorit (Tahap sebelumnya)
  final Set<String> _favorites = {};
  Set<String> get favorites => _favorites;

  // 2. Implementasi method loadCourses()
  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners(); // Beritahu UI untuk menampilkan animasi loading
    
    try {
      courses = await repository.getCourses(); // Memuat data
    } catch (e) {
      error = e.toString(); // Menangkap error jika gagal
    } finally {
      isLoading = false;
      notifyListeners(); // Beritahu UI bahwa proses selesai (sukses/gagal)
    }
  }

  // Method Favorit (Tahap sebelumnya)
  void toggleFavorite(String courseCode) {
    if (_favorites.contains(courseCode)) {
      _favorites.remove(courseCode);
    } else {
      _favorites.add(courseCode);
    }
    notifyListeners(); 
  }
}