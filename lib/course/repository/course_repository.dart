import 'package:meta/meta.dart';
import 'package:course_flutter_app/course/course.dart';

class CourseRepository {
  final CourseDataProvider dataProvider;

  CourseRepository({required this.dataProvider});

  Future<Course> createCourse(Course course) async {
    return await dataProvider.createCourse(course);
  }

  Future<List<Course>> getCourses() async {
    return await dataProvider.getCourses();
  }

  Future<void> updateCourse(Course course) async {
    await dataProvider.updateCourse(course);
  }

  Future<void> deleteCourse(String id) async {
    await dataProvider.deleteCourse(id);
  }
}