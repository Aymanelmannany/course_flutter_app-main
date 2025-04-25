import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_observer.dart';
import 'course/course.dart';
import 'package:http/http.dart' as http;

void main() {
  Bloc.observer = SimpleBlocObserver();

  final CourseRepository courseRepository = CourseRepository(
    dataProvider: CourseDataProvider(
      httpClient: http.Client(),
    ),
  );

  runApp(CourseApp(courseRepository: courseRepository));
}

class CourseApp extends StatelessWidget {
  final CourseRepository courseRepository;

  CourseApp({required this.courseRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: courseRepository,
      child: BlocProvider(
        create: (context) => CourseBloc(repository: courseRepository)
          ..add(CourseLoad()),
        child: MaterialApp(
          title: 'Course App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          onGenerateRoute: CourseAppRoute.generateRoute,
        ),
      ),
    );
  }
}