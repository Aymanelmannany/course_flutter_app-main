import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:course_flutter_app/course/course.dart';
import 'package:flutter/services.dart';  // Add this import

class AddUpdateCourse extends StatefulWidget {
  static const routeName = 'courseAddUpdate';
  final CourseArgument args;

  const AddUpdateCourse({required this.args});
  @override
  _AddUpdateCourseState createState() => _AddUpdateCourseState();
}

class _AddUpdateCourseState extends State<AddUpdateCourse> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _course = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.args.edit ? "Edit Course" : "Add New Course"}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  initialValue: widget.args.edit ? widget.args.course?.code : '',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter course code';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Course Code'),
                  onSaved: (value) {
                    setState(() {
                      this._course["code"] = value;
                    });
                  }),
              TextFormField(
                  initialValue: widget.args.edit ? widget.args.course?.title : '',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter course title';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Course Title'),
                  onSaved: (value) {
                    this._course["title"] = value;
                  }),
            TextFormField(
              initialValue: widget.args.edit
                  ? widget.args.course?.ects.toString()
                  : '',
              keyboardType: TextInputType.number,  // Add this line
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter course ECTS';
                }
                if (int.tryParse(value) == null) {  // Add validation for number
                  return 'Please enter a valid number';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Course ECTS'),
              onSaved: (value) {
                setState(() {
                  this._course["ects"] = int.parse(value!);  // Add null assertion
                });
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,  // Only allow numbers
              ],
            ),
              TextFormField(
                  initialValue:
                  widget.args.edit ? widget.args.course?.description : '',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter course description';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Course Description'),
                  onSaved: (value) {
                    setState(() {
                      this._course["description"] = value;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form!.validate()) {
                      form.save();
                      final CourseEvent event = widget.args.edit
                          ? CourseUpdate(
                        Course(
                          id: widget.args.course!.id,
                          code: this._course["code"],
                          title: this._course["title"],
                          ects: this._course["ects"],
                          description: this._course["description"],
                        ),
                      )
                          : CourseCreate(
                        Course(
                          code: this._course["code"],
                          title: this._course["title"],
                          ects: this._course["ects"],
                          description: this._course["description"], id: '',
                        ),
                      );
                      BlocProvider.of<CourseBloc>(context).add(event);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          CoursesList.routeName, (route) => false);
                    }
                  },
                  label: Text('SAVE'),
                  icon: Icon(Icons.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}