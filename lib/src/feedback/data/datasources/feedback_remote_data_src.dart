import 'dart:convert';

import 'package:available/core/errors/exception.dart';
import 'package:available/core/helpers/data_source_helper.dart';
import 'package:available/core/utils/network_constants.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/feedback/data/models/feedback_model.dart';
import 'package:available/src/feedback/domain/entities/feedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

// Ignore it since we need this to be an interface
// ignore: one_member_abstracts
abstract interface class FeedbackRemoteDataSrc {
  Future<FeedbackModel> leaveFeedback(Feedback feedback);
}

class FeedbackRemoteDataSrcImpl implements FeedbackRemoteDataSrc {
  const FeedbackRemoteDataSrcImpl({
    required http.Client httpClient,
    required FirebaseAuth authClient,
  })  : _httpClient = httpClient,
        _authClient = authClient;

  final http.Client _httpClient;
  final FirebaseAuth _authClient;

  @override
  Future<FeedbackModel> leaveFeedback(Feedback feedback) async {
    final uri = Uri.https(
      NetworkConstants.authority,
      NetworkConstants.leaveFeedbackEndpoint,
    );

    try {
      await DataSourceHelper.authorizeUser(_authClient);
      final response = await _httpClient.post(
        uri,
        body: (feedback as FeedbackModel).toRemoteJson(),
        headers: {'Content-Type': 'application/json'},
      );

      final payload = jsonDecode(response.body) as DataMap;

      if (response.statusCode != 201) {
        return DataSourceHelper.handleRemoteSourceException<FeedbackModel>(
          payload,
          repositoryName: 'FeedbackRemoteDataSrcImpl',
          methodName: 'leaveFeedback',
          statusCode: '${response.statusCode} Error',
          errorMessage: payload['message'] as String,
        );
      }

      return FeedbackModel.fromMap(payload);
    } on ServerException {
      rethrow;
    } on Exception catch (e, s) {
      return DataSourceHelper.handleRemoteSourceException<FeedbackModel>(
        e,
        repositoryName: 'FeedbackRemoteDataSrcImpl',
        methodName: 'leaveFeedback',
        stackTrace: s,
      );
    }
  }
}
