import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/course_widgets.dart';

class CoursesPage extends StatelessWidget {
  final List<Course> courses;
  const CoursesPage({super.key, required this.courses}); 

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Katalog Mata Kuliah', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: courses.length,
                  itemBuilder: (context, index) => CourseCard(index: index + 1, course: courses[index]),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth < 900 ? 2 : 3,
                  crossAxisSpacing: 16, mainAxisSpacing: 16, mainAxisExtent: 100, 
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) => CourseCard(index: index + 1, course: courses[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}