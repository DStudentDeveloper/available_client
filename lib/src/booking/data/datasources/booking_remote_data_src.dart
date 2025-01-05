import 'dart:convert';

import 'package:available/core/errors/exception.dart';
import 'package:available/core/helpers/data_source_helper.dart';
import 'package:available/core/utils/network_constants.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/booking/data/models/booking_model.dart';
import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

abstract class BookingRemoteDataSrc {
  Future<BookingModel> bookRoom(Booking booking);

  Future<void> cancelBooking(String bookingId);

  Future<BookingModel> updateBooking(Booking booking);

  Future<List<BookingModel>> getUserBookings(String userId);
}

class BookingRemoteDataSrcImpl implements BookingRemoteDataSrc {
  const BookingRemoteDataSrcImpl({
    required http.Client httpClient,
    required FirebaseAuth authClient,
  })  : _httpClient = httpClient,
        _authClient = authClient;

  final http.Client _httpClient;
  final FirebaseAuth _authClient;

  @override
  Future<BookingModel> bookRoom(Booking booking) async {
    final uri = Uri.http(
      NetworkConstants.authority,
      NetworkConstants.bookRoomEndpoint,
    );

    try {
      await DataSourceHelper.authorizeUser(_authClient);
      final response = await _httpClient.post(
        uri,
        body: (booking as BookingModel).toJson(),
        headers: {'Content-Type': 'application/json'},
      );

      final payload = jsonDecode(response.body) as DataMap;

      if (response.statusCode != 201) {
        return DataSourceHelper.handleRemoteSourceException<BookingModel>(
          payload,
          repositoryName: 'BookingRemoteDataSrcImpl',
          methodName: 'bookRoom',
          statusCode: '${response.statusCode} Error',
          errorMessage: payload['message'] as String,
        );
      }

      return BookingModel.fromMap(jsonDecode(response.body) as DataMap);
    } on ServerException {
      rethrow;
    } on Exception catch (e, s) {
      return DataSourceHelper.handleRemoteSourceException<BookingModel>(
        e,
        repositoryName: 'BookingRemoteDataSrcImpl',
        methodName: 'bookRoom',
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    final uri = Uri.http(
      NetworkConstants.authority,
      NetworkConstants.cancelBookingEndpoint(bookingId),
    );

    try {
      await DataSourceHelper.authorizeUser(_authClient);
      final response = await _httpClient.delete(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 204) {
        final payload = jsonDecode(response.body) as DataMap;
        return DataSourceHelper.handleRemoteSourceException<void>(
          payload,
          repositoryName: 'BookingRemoteDataSrcImpl',
          methodName: 'cancelBooking',
          statusCode: '${response.statusCode} Error',
          errorMessage: payload['message'] as String,
        );
      }
    } on ServerException {
      rethrow;
    } on Exception catch (e, s) {
      return DataSourceHelper.handleRemoteSourceException<void>(
        e,
        repositoryName: 'BookingRemoteDataSrcImpl',
        methodName: 'cancelBooking',
        stackTrace: s,
      );
    }
  }

  @override
  Future<BookingModel> updateBooking(Booking booking) async {
    final uri = Uri.http(
      NetworkConstants.authority,
      NetworkConstants.updateBookingEndpoint(booking.id),
    );

    try {
      await DataSourceHelper.authorizeUser(_authClient);
      final response = await _httpClient.patch(
        uri,
        body: jsonEncode(
          {'timeRange': (booking as BookingModel).toMap()['timeRange']},
        ),
        headers: {'Content-Type': 'application/json'},
      );

      final payload = jsonDecode(response.body) as DataMap;

      if (response.statusCode != 200) {
        return DataSourceHelper.handleRemoteSourceException<BookingModel>(
          payload,
          repositoryName: 'BookingRemoteDataSrcImpl',
          methodName: 'updateBooking',
          statusCode: '${response.statusCode} Error',
          errorMessage: payload['message'] as String,
        );
      }

      return BookingModel.fromMap(payload);
    } on ServerException {
      rethrow;
    } on Exception catch (e, s) {
      return DataSourceHelper.handleRemoteSourceException<BookingModel>(
        e,
        repositoryName: 'BookingRemoteDataSrcImpl',
        methodName: 'updateBooking',
        stackTrace: s,
      );
    }
  }

  @override
  Future<List<BookingModel>> getUserBookings(String userId) async {
    final uri = Uri.http(
      NetworkConstants.authority,
      NetworkConstants.getUserBookingsEndpoint,
      {'representativeId': userId},
    );

    try {
      await DataSourceHelper.authorizeUser(_authClient);
      final response = await _httpClient.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      final payload = jsonDecode(response.body);

      if (response.statusCode != 200) {
        payload as DataMap;
        return DataSourceHelper.handleRemoteSourceException<List<BookingModel>>(
          payload,
          repositoryName: 'BookingRemoteDataSrcImpl',
          methodName: 'getUserBookings',
          statusCode: '${response.statusCode} Error',
          errorMessage: payload['message'] as String,
        );
      }

      return List<DataMap>.from(payload as List)
          .map(BookingModel.fromMap)
          .toList();
    } on ServerException {
      rethrow;
    } on Exception catch (e, s) {
      return DataSourceHelper.handleRemoteSourceException<List<BookingModel>>(
        e,
        repositoryName: 'BookingRemoteDataSrcImpl',
        methodName: 'getUserBookings',
        stackTrace: s,
      );
    }
  }
}
