import 'dart:convert';

import 'package:available/core/errors/exception.dart';
import 'package:available/core/helpers/data_source_helper.dart';
import 'package:available/core/utils/network_constants.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/block/data/models/block_model.dart';
import 'package:available/src/room/data/models/room_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

abstract class BlockRemoteDataSrc {
  Future<List<BlockModel>> getAllBlocks();

  Future<BlockModel> getBlockById(String blockId);

  Future<List<RoomModel>> getBlockRooms(String blockId);
}

class BlockRemoteDataSrcImpl implements BlockRemoteDataSrc {
  const BlockRemoteDataSrcImpl({
    required http.Client httpClient,
    required FirebaseAuth authClient,
  })  : _httpClient = httpClient,
        _authClient = authClient;

  final http.Client _httpClient;
  final FirebaseAuth _authClient;

  @override
  Future<List<BlockModel>> getAllBlocks() async {
    final uri = Uri.http(
      NetworkConstants.authority,
      NetworkConstants.getAllBlocksEndpoint,
    );
    try {
      await DataSourceHelper.authorizeUser(_authClient);
      final response = await _httpClient.get(uri);

      if (response.statusCode != 200) {
        final payload = jsonDecode(response.body) as DataMap;
        return DataSourceHelper.handleRemoteSourceException<List<BlockModel>>(
          payload,
          repositoryName: 'BlockRemoteDataSrcImpl',
          methodName: 'getAllBlocks',
          statusCode: '${response.statusCode} Error',
          errorMessage: payload['message'] as String,
        );
      }

      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map(BlockModel.fromMap)
          .toList();
    } on ServerException {
      rethrow;
    } on Exception catch (e, s) {
      return DataSourceHelper.handleRemoteSourceException<List<BlockModel>>(
        e,
        repositoryName: 'BlockRemoteDataSrcImpl',
        methodName: 'getAllBlocks',
        stackTrace: s,
      );
    }
  }

  @override
  Future<BlockModel> getBlockById(String blockId) async {
    final uri = Uri.http(
      NetworkConstants.authority,
      NetworkConstants.getBlockByIdEndpoint(blockId),
    );
    try {
      await DataSourceHelper.authorizeUser(_authClient);
      final response = await _httpClient.get(uri);

      final payload = jsonDecode(response.body) as DataMap;
      if (response.statusCode != 200) {
        return DataSourceHelper.handleRemoteSourceException<BlockModel>(
          payload,
          repositoryName: 'BlockRemoteDataSrcImpl',
          methodName: 'getBlockById',
          statusCode: '${response.statusCode} Error',
          errorMessage: payload['message'] as String,
        );
      }

      return BlockModel.fromMap(payload);
    } on ServerException {
      rethrow;
    } on Exception catch (e, s) {
      return DataSourceHelper.handleRemoteSourceException<BlockModel>(
        e,
        repositoryName: 'BlockRemoteDataSrcImpl',
        methodName: 'getBlockById',
        stackTrace: s,
      );
    }
  }

  @override
  Future<List<RoomModel>> getBlockRooms(String blockId) async {
    final uri = Uri.http(
      NetworkConstants.authority,
      NetworkConstants.getBlockRoomsEndpoint(blockId),
    );
    try {
      await DataSourceHelper.authorizeUser(_authClient);
      final response = await _httpClient.get(uri);

      if (response.statusCode != 200) {
        final payload = jsonDecode(response.body) as DataMap;
        return DataSourceHelper.handleRemoteSourceException<List<RoomModel>>(
          payload,
          repositoryName: 'BlockRemoteDataSrcImpl',
          methodName: 'getBlockRooms',
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
        repositoryName: 'BlockRemoteDataSrcImpl',
        methodName: 'getBlockRooms',
        stackTrace: s,
      );
    }
  }
}
