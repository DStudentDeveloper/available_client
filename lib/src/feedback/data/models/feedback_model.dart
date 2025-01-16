import 'dart:convert';

import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/feedback/domain/entities/feedback.dart';

class FeedbackModel extends Feedback {
  const FeedbackModel({
    required super.id,
    required super.message,
    super.representativeId,
    super.representativeName,
    super.representativeCourse,
    super.representativeLevel,
  });

  const FeedbackModel.empty()
      : this(
          id: 'Test String',
          message: 'Test String',
          representativeId: null,
          representativeName: null,
          representativeCourse: null,
          representativeLevel: null,
        );

  factory FeedbackModel.fromJson(String source) =>
      FeedbackModel.fromMap(jsonDecode(source) as DataMap);

  FeedbackModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          message: map['message'] as String,
          representativeId: map['representativeId'] as String?,
          representativeName: map['representativeName'] as String?,
          representativeCourse: map['representativeCourse'] as String?,
          representativeLevel: map['representativeLevel'] as String?,
        );

  FeedbackModel copyWith({
    String? id,
    String? message,
    String? representativeId,
    String? representativeName,
    String? representativeCourse,
    String? representativeLevel,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      message: message ?? this.message,
      representativeId: representativeId ?? this.representativeId,
      representativeName: representativeName ?? this.representativeName,
      representativeCourse: representativeCourse ?? this.representativeCourse,
      representativeLevel: representativeLevel ?? this.representativeLevel,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'representativeId': representativeId,
      'representativeName': representativeName,
      'representativeCourse': representativeCourse,
      'representativeLevel': representativeLevel,
    };
  }

  DataMap toRemoteMap() => toMap()..remove('id');

  String toJson() => jsonEncode(toMap());

  String toRemoteJson() => jsonEncode(toRemoteMap());
}
