import 'package:flutter/material.dart';

// Identitas Mahasiswa:
// Nama: Ni Komang Tri Lindyasari
// NIM : 2415051017

class CourseProvider extends ChangeNotifier {
  // 1. Tambahkan collection favorites (Single Source of Truth)
  final Set<String> _favorites = {};

  // Getter agar data bisa dibaca oleh widget UI
  Set<String> get favorites => _favorites;

  // 2. Method untuk mengubah state
  void toggleFavorite(String courseCode) {
    if (_favorites.contains(courseCode)) {
      _favorites.remove(courseCode);
    } else {
      _favorites.add(courseCode);
    }
    
    // 3. Wajib dipanggil untuk merender ulang widget yang memantau state ini
    notifyListeners(); 
  }
}