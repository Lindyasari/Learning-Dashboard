import 'dart:convert'; // Pastikan ini ada untuk jsonEncode/jsonDecode
import 'package:http/http.dart' as http;
import '../models/course.dart';

// Nama: Ni Komang Tri Lindyasari
// NIM: 2415051017

class CourseApiService {
  CourseApiService(this.baseUrl);
  final String baseUrl;

  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));
    if (response.statusCode != 200) throw Exception('Gagal mengambil course');
    final List data = jsonDecode(response.body) as List;
    return data.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Course.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Gagal membuat course');
  }
}