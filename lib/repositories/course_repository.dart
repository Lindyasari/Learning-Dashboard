import '../services/course_service.dart';
import '../models/course.dart';

// Identitas Mahasiswa:
// Nama: Ni Komang Tri Lindyasari
// NIM : 2415051017

class CourseRepository {
  final CourseService service;

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }
}