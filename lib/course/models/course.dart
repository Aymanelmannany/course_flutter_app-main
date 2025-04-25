import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Course extends Equatable {
  const Course({
    required this.id,
    required this.title,
    required this.code,
    required this.description,
    required this.ects,
  });

  final String id;
  final String title;
  final String code;
  final String description;
  final int ects;

  @override
  List<Object> get props => [id, title, code, description, ects];

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      title: json['title'],
      code: json['code'],
      description: json['description'],
      ects: json['ects'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'code': code,
      'description': description,
      'ects': ects,
    };
  }

  @override
  String toString() => 'Course { id: $id, code: $code, ects: $ects }';
}