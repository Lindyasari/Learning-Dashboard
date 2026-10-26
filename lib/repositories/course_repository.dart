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

  Future<Course> createCourse(Course course) {
    return service.createCourse(course);
  }

  Future<void> updateCourse(int id, Course course) {
    return service.updateCourse(id, course);
  }

  Future<void> deleteCourse(int id) {
    return service.deleteCourse(id);
  }
}