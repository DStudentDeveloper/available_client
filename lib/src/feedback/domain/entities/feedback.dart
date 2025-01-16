import 'package:equatable/equatable.dart';

class Feedback extends Equatable {
  const Feedback({
    required this.id,
    required this.message,
    this.representativeId,
    this.representativeName,
    this.representativeCourse,
    this.representativeLevel,
  });

  const Feedback.empty()
      : id = 'Test String',
        message = 'Test String',
        representativeId = null,
        representativeName = null,
        representativeCourse = null,
        representativeLevel = null;

  final String id;
  final String message;
  final String? representativeId;
  final String? representativeName;
  final String? representativeCourse;
  final String? representativeLevel;

  @override
  List<dynamic> get props => [
        id,
        message,
        representativeId,
        representativeName,
        representativeCourse,
        representativeLevel,
      ];
}
