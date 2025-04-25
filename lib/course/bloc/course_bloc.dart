import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:course_flutter_app/course/bloc/bloc.dart';
import 'package:course_flutter_app/course/course.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository repository;

  CourseBloc({required this.repository})
      : super(CourseLoading()) {
    // Register event handlers in the constructor
    on<CourseLoad>(_onCourseLoad);
    on<CourseCreate>(_onCourseCreate);
    on<CourseUpdate>(_onCourseUpdate);
    on<CourseDelete>(_onCourseDelete);
  }

  Future<void> _onCourseLoad(
      CourseLoad event,
      Emitter<CourseState> emit,
      ) async {
    emit(CourseLoading());
    try {
      final courses = await repository.getCourses();
      emit(CoursesLoadSuccess(courses));
    } catch (_) {
      emit(CourseOperationFailure());
    }
  }

  Future<void> _onCourseCreate(
      CourseCreate event,
      Emitter<CourseState> emit,
      ) async {
    try {
      emit(CourseLoading());
      await repository.createCourse(event.course);
      final courses = await repository.getCourses();
      emit(CoursesLoadSuccess(courses));
    } catch (e) {
      print('Creation error: $e');
      emit(CourseOperationFailure());
      // Optionally re-emit the previous state
      final previousCourses = await repository.getCourses();
      emit(CoursesLoadSuccess(previousCourses));
    }
  }

  Future<void> _onCourseUpdate(
      CourseUpdate event,
      Emitter<CourseState> emit,
      ) async {
    try {
      await repository.updateCourse(event.course);
      final courses = await repository.getCourses();
      emit(CoursesLoadSuccess(courses));
    } catch (_) {
      emit(CourseOperationFailure());
    }
  }

  Future<void> _onCourseDelete(CourseDelete event, Emitter<CourseState> emit) async {
    try {
      await repository.deleteCourse(event.course.id);
      final courses = await repository.getCourses();  // Refresh list
      emit(CoursesLoadSuccess(courses));
    } catch (e) {
      print('Delete error: $e');
      emit(CourseOperationFailure());
      // Optional: Re-show previous courses
      final previousCourses = await repository.getCourses();
      emit(CoursesLoadSuccess(previousCourses));
    }
  }
}