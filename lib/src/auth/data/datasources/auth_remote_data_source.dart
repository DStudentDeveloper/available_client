import 'package:available/core/errors/exception.dart';
import 'package:available/core/helpers/data_source_helper.dart';
import 'package:available/src/auth/data/models/course_representative_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDataSource {
  Future<CourseRepresentativeModel> login({
    required String email,
    required String password,
  });

  Future<void> initiatePasswordReset(String email);

  Future<String> verifyPasswordResetCode(String code);

  Future<void> resetPassword({required String code, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<void> initiatePasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      return DataSourceHelper.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AuthRemoteDataSourceImpl',
        methodName: 'initiatePasswordReset',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } on Exception catch (e, s) {
      return DataSourceHelper.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AuthRemoteDataSourceImpl',
        methodName: 'initiatePasswordReset',
        stackTrace: s,
      );
    }
  }

  @override
  Future<CourseRepresentativeModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        await _auth.signOut();
        throw const ServerException(
          message: 'User not found',
          title: 'UserNotFound',
        );
      }
      final userDoc = await _firestore
          .collection('course_representatives')
          .doc(user.uid)
          .get()
          .then((value) => value.data());
      if (userDoc == null) {
        await _auth.signOut();
        throw const ServerException(
          message: 'User not found',
          title: 'UserNotFound',
        );
      }
      return CourseRepresentativeModel.fromMap(userDoc);
    } on FirebaseException catch (e) {
      return DataSourceHelper.handleRemoteSourceException<
          CourseRepresentativeModel>(
        e,
        repositoryName: 'AuthRemoteDataSourceImpl',
        methodName: 'login',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } on Exception catch (e, s) {
      return DataSourceHelper.handleRemoteSourceException<
          CourseRepresentativeModel>(
        e,
        repositoryName: 'AuthRemoteDataSourceImpl',
        methodName: 'login',
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> resetPassword({
    required String code,
    required String password,
  }) async {
    try {
      await _auth.confirmPasswordReset(code: code, newPassword: password);
      await _auth.signOut();
    } on FirebaseException catch (e) {
      return DataSourceHelper.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AuthRemoteDataSourceImpl',
        methodName: 'resetPassword',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } on Exception catch (e, s) {
      return DataSourceHelper.handleRemoteSourceException<void>(
        e,
        repositoryName: 'AuthRemoteDataSourceImpl',
        methodName: 'resetPassword',
        stackTrace: s,
      );
    }
  }

  @override
  Future<String> verifyPasswordResetCode(String code) async {
    try {
      return _auth.verifyPasswordResetCode(code);
    } on FirebaseException catch (e) {
      return DataSourceHelper.handleRemoteSourceException<String>(
        e,
        repositoryName: 'AuthRemoteDataSourceImpl',
        methodName: 'verifyPasswordResetCode',
        stackTrace: e.stackTrace,
        statusCode: e.code,
        errorMessage: e.message,
      );
    } on ServerException {
      rethrow;
    } on Exception catch (e, s) {
      return DataSourceHelper.handleRemoteSourceException<String>(
        e,
        repositoryName: 'AuthRemoteDataSourceImpl',
        methodName: 'verifyPasswordResetCode',
        stackTrace: s,
      );
    }
  }
}
