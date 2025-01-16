import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/feedback/domain/entities/feedback.dart';

// Ignore it since we need this to be an interface
// ignore: one_member_abstracts
abstract interface class FeedbackRepo {
  const FeedbackRepo();

  ResultFuture<Feedback> leaveFeedback(Feedback feedback);
}
