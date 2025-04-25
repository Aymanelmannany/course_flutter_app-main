import 'dart:convert';
import 'package:course_flutter_app/course/models/course.dart';
import 'package:http/http.dart' as http;

class CourseDataProvider {
  final _baseUrl = 'http://192.168.58.128:3200';
  final http.Client httpClient;

  CourseDataProvider({required this.httpClient});

  Future<Course> createCourse(Course course) async {
    final response = await httpClient.post(
      Uri.parse('$_baseUrl/courses'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': course.title,
        'code': course.code,
        'description': course.description,
        'ects': course.ects,
        // Don't send ID - let backend generate it
      }),
    );

    if (response.statusCode == 201) {  // Check for 201 Created
      return Course.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create course. Status: ${response.statusCode}');
    }
  }

  Future<List<Course>> getCourses() async {
    final response = await httpClient.get(
      Uri.parse('$_baseUrl/courses'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Course.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<void> deleteCourse(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/courses/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    print('[DELETE] Response: ${response.statusCode} - ${response.body}');  // Debug log

    if (response.statusCode != 204) {  // 204 = Success (No Content)
      throw Exception('Delete failed. Status: ${response.statusCode}');
    }
  }

  Future<void> updateCourse(Course course) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/courses/${course.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );

    print('[DEBUG] Update Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Update failed. Status: ${response.statusCode}');
    }
  }
}