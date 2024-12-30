import 'dart:convert';

import 'package:available/core/errors/exception.dart';
import 'package:available/core/helpers/data_source_helper.dart';
import 'package:available/core/utils/network_constants.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/booking/data/models/booking_model.dart';
import 'package:available/src/room/data/models/room_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

abstract class RoomRemoteDataSrc {
  Future<List<RoomModel>> getAllRooms();

  Future<List<BookingModel>> getRoomBookings(String roomId);

  Future<RoomModel> getRoomById(String roomId);
}

class RoomRemoteDataSrcImpl implements RoomRemoteDataSrc {
  const RoomRemoteDataSrcImpl({
    required http.Client httpClient,
    required FirebaseAuth authClient,
  })  : _httpClient = httpClient,
        _authClient = authClient;

  final http.Client _httpClient;
  final FirebaseAuth _authClient;

  @override
  Future<List<RoomModel>> getAllRooms() async {
    final uri = Uri.http(
      NetworkConstants.authority,
      NetworkConstants.getAllRoomsEndpoint,
    );

    try {
      await DataSourceHelper.authorizeUser(_authClient);
      final response = await _httpClient.get(uri);

      if (response.statusCode != 200) {
        final payload = jsonDecode(response.body) as DataMap;
        return DataSourceHelper.handleRemoteSourceException<List<RoomModel>>(
          payload,
          repositoryName: 'RoomRemoteDataSrcImpl',
          methodName: 'getAllRooms',
          statusCode: '${response.statusCode} Error',
          errorMessage: payload['message'] as String,
        );
      }

      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map(RoomModel.fromMap)
          .toList();
    } on ServerException {
      rethrow;
    } on Exception catch (e, s) {
      return DataSourceHelper.handleRemoteSourceException<List<RoomModel>>(
        e,
        repositoryName: 'RoomRemoteDataSrcImpl',
        methodName: 'getAllRooms',
        stackTrace: s,
      );
    }
  }

  @override
  Future<List<BookingModel>> getRoomBookings(String roomId) async {
    final uri = Uri.http(
      NetworkConstants.authority,
      NetworkConstants.getRoomBookingsEndpoint(roomId),
    );

    try {
      await DataSourceHelper.authorizeUser(_authClient);
      final response = await _httpClient.get(uri);

      if (response.statusCode != 200) {
        final payload = jsonDecode(response.body) as DataMap;
        return DataSourceHelper.handleRemoteSourceException<List<BookingModel>>(
          payload,
          repositoryName: 'RoomRemoteDataSrcImpl',
          methodName: 'getRoomBookings',
          statusCode: '${response.statusCode} Error',
          errorMessage: payload['message'] as String,
        );
      }

      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map(BookingModel.fromMap)
          .toList();
    } on ServerException {
      rethrow;
    } on Exception catch (e, s) {
      return DataSourceHelper.handleRemoteSourceException<List<BookingModel>>(
        e,
        repositoryName: 'RoomRemoteDataSrcImpl',
        methodName: 'getRoomBookings',
        stackTrace: s,
      );
    }
  }

  @override
  Future<RoomModel> getRoomById(String roomId) async {
    final uri = Uri.http(
      NetworkConstants.authority,
      NetworkConstants.getRoomByIdEndpoint(roomId),
    );

    try {
      await DataSourceHelper.authorizeUser(_authClient);
      final response = await _httpClient.get(uri);

      final payload = jsonDecode(response.body) as DataMap;
      if (response.statusCode != 200) {
        return DataSourceHelper.handleRemoteSourceException<RoomModel>(
          payload,
          repositoryName: 'RoomRemoteDataSrcImpl',
          methodName: 'getRoomById',
          statusCode: '${response.statusCode} Error',
          errorMessage: payload['message'] as String,
        );
      }

      return RoomModel.fromMap(payload);
    } on ServerException {
      rethrow;
    } on Exception catch (e, s) {
      return DataSourceHelper.handleRemoteSourceException<RoomModel>(
        e,
        repositoryName: 'RoomRemoteDataSrcImpl',
        methodName: 'getRoomById',
        stackTrace: s,
      );
    }
  }
}
