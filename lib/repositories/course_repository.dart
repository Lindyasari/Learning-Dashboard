import '../services/course_api_service.dart';
import '../models/course.dart';

// Nama: Ni Komang Tri Lindyasari
// NIM : 2415051017

class CourseRepository {
  final CourseApiService service;

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.getCourses();
  }
}