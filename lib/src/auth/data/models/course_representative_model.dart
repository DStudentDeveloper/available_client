import 'package:available/core/interfaces/model.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/auth/domain/entities/course_representative.dart';

class CourseRepresentativeModel extends CourseRepresentative implements Model {
  const CourseRepresentativeModel({
    required super.id,
    required super.courseId,
    required super.courseName,
    required super.facultyId,
    required super.facultyName,
    required super.indexNumber,
    required super.levelId,
    required super.levelName,
    required super.name,
    required super.studentEmail,
  });

  const CourseRepresentativeModel.empty()
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

  CourseRepresentativeModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          courseId: map['courseId'] as String,
          courseName: map['courseName'] as String,
          facultyId: map['facultyId'] as String,
          facultyName: map['facultyName'] as String,
          indexNumber: map['indexNumber'] as String,
          levelId: map['levelId'] as String,
          levelName: map['levelName'] as String,
          name: map['name'] as String,
          studentEmail: map['studentEmail'] as String,
        );

  @override
  CourseRepresentativeModel copyWith({
    String? id,
    String? courseId,
    String? courseName,
    String? facultyId,
    String? facultyName,
    String? indexNumber,
    String? levelId,
    String? levelName,
    String? name,
    String? studentEmail,
  }) {
    return CourseRepresentativeModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      facultyId: facultyId ?? this.facultyId,
      facultyName: facultyName ?? this.facultyName,
      indexNumber: indexNumber ?? this.indexNumber,
      levelId: levelId ?? this.levelId,
      levelName: levelName ?? this.levelName,
      name: name ?? this.name,
      studentEmail: studentEmail ?? this.studentEmail,
    );
  }

  @override
  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'courseId': courseId,
      'courseName': courseName,
      'facultyId': facultyId,
      'facultyName': facultyName,
      'indexNumber': indexNumber,
      'levelId': levelId,
      'levelName': levelName,
      'name': name,
      'studentEmail': studentEmail,
    };
  }
}
