// Nama: Ni Komang Tri Lindyasari
// NIM: 2415051017

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  String get _uid => supabase.auth.currentUser!.id;

  @override
  Future<List<Course>> getCourses() async {
    final data = await supabase
        .from('courses')
        .select()
        .order('id');

    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final payload = {
      ...course.toJson(),
      'owner_id': _uid,
    };

    final row = await supabase
        .from('courses')
        .insert(payload)
        .select()
        .single();

    return Course.fromJson(row);
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    final rows = await supabase
        .from('courses')
        .update(course.toJson())
        .eq('id', id)
        .select();

    if ((rows as List).isEmpty) {
      throw Exception('Akses ditolak: Anda hanya boleh mengubah course milik sendiri.');
    }
  }

  @override
  Future<void> deleteCourse(int id) async {
    final rows = await supabase
        .from('courses')
        .delete()
        .eq('id', id)
        .select();

    if ((rows as List).isEmpty) {
      throw Exception('Akses ditolak: Anda hanya boleh menghapus course milik sendiri.');
    }
  }
}