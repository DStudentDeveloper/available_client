import 'package:available/core/interfaces/usecase.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/feedback/domain/entities/feedback.dart';
import 'package:available/src/feedback/domain/repos/feedback_repo.dart';

class LeaveFeedback implements Usecase<Feedback, Feedback> {
  const LeaveFeedback(this._repo);

  final FeedbackRepo _repo;

  @override
  ResultFuture<Feedback> call(Feedback params) => _repo.leaveFeedback(params);
}
