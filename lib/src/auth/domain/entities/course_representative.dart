import 'package:equatable/equatable.dart';

class CourseRepresentative extends Equatable {
  const CourseRepresentative({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.facultyId,
    required this.facultyName,
    required this.indexNumber,
    required this.levelId,
    required this.levelName,
    required this.name,
    required this.studentEmail,
  });

  const CourseRepresentative.empty()
      : this(
          id: 'Test String',
          courseId: 'Test String',
          courseName: 'Test String',
          facultyId: 'Test String',
          facultyName: 'Test String',
          indexNumber: 'Test String',
          levelId: 'Test String',
          levelName: 'Test String',
          name: 'Test String',
          studentEmail: 'Test String',
        );

  final String id;
  final String courseId;
  final String courseName;
  final String facultyId;
  final String facultyName;
  final String indexNumber;
  final String levelId;
  final String levelName;
  final String name;
  final String studentEmail;

  @override
  List<Object> get props => [
        id,
        courseId,
        courseName,
        facultyId,
        facultyName,
        indexNumber,
        levelId,
        levelName,
        name,
        studentEmail,
      ];

  @override
  String toString() {
    return 'CurrentUser{courseName: $courseName, facultyName: $facultyName, '
        'indexNumber: $indexNumber, levelName: $levelName, name: $name, '
        'studentEmail: $studentEmail}';
  }
}
