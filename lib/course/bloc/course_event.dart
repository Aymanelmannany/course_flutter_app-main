import 'package:equatable/equatable.dart';
import 'package:course_flutter_app/course/course.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();
}

class CourseLoad extends CourseEvent {
  const CourseLoad();

  @override
  List<Object> get props => [];
}

class CourseCreate extends CourseEvent {
  final Course course;

  const CourseCreate(this.course);

  @override
  List<Object> get props => [course];

  @override
  String toString() => 'Course Created {course: $course}';
}

class CourseUpdate extends CourseEvent {
  final Course course;

  const CourseUpdate(this.course);

  @override
  List<Object> get props => [course];

  @override
  String toString() => 'Course Updated {course: $course}';
}

class CourseDelete extends CourseEvent {
  final Course course;

  const CourseDelete(this.course);

  @override
  List<Object> get props => [course];

  @override
  String toString() => 'Course Deleted {course: $course}';
}