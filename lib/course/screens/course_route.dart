import 'package:flutter/material.dart';
import 'package:course_flutter_app/course/course.dart';

class CourseAppRoute {
  static Route generateRoute(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) => CoursesList());
    }

    if (settings.name == AddUpdateCourse.routeName) {
      final args = settings.arguments as CourseArgument; // Explicit cast here
      return MaterialPageRoute(
          builder: (context) => AddUpdateCourse(
            args: args,
          ));
    }

    if (settings.name == CourseDetail.routeName) {
      final course = settings.arguments as Course; // Explicit cast here
      return MaterialPageRoute(
          builder: (context) => CourseDetail(
            course: course,
          ));
    }

    return MaterialPageRoute(builder: (context) => CoursesList());
  }
}

class CourseArgument {
  final Course? course;
  final bool edit;

  CourseArgument({this.course, required this.edit});
}