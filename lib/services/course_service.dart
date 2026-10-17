import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/course.dart';

// Identitas Mahasiswa:
// Nama: Ni Komang Tri Lindyasari
// NIM : 2415051017

class CourseService {
  Future<List<Course>> loadCourses() async {
    
    await Future.delayed(const Duration(seconds: 1));

    final jsonString = await rootBundle.loadString('assets/data/student_data_salah.json');
    
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    
    final list = data['courses'] as List<dynamic>;
    
    return list.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }
}