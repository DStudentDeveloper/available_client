import 'package:available/core/errors/exception.dart';
import 'package:available/core/errors/failure.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/feedback/data/datasources/feedback_remote_data_src.dart';
import 'package:available/src/feedback/domain/entities/feedback.dart';
import 'package:available/src/feedback/domain/repos/feedback_repo.dart';
import 'package:dartz/dartz.dart';

class FeedbackRepoImpl implements FeedbackRepo {
  const FeedbackRepoImpl(this._remoteDataSource);

  final FeedbackRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<Feedback> leaveFeedback(Feedback feedback) async {
    try {
      final result = await _remoteDataSource.leaveFeedback(feedback);
      return Right(result);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }
}
