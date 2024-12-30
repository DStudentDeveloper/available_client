import 'package:available/core/errors/exception.dart';
import 'package:available/core/errors/failure.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/block/data/datasources/block_remote_data_src.dart';
import 'package:available/src/block/domain/entities/block.dart';
import 'package:available/src/block/domain/repos/block_repo.dart';
import 'package:available/src/room/domain/entities/room.dart';
import 'package:dartz/dartz.dart';

class BlockRepoImpl implements BlockRepo {
  const BlockRepoImpl(this._remoteDataSource);

  final BlockRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<Block>> getAllBlocks() async {
    try {
      final result = await _remoteDataSource.getAllBlocks();
      return Right(result);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }

  @override
  ResultFuture<Block> getBlockById(String blockId) async {
    try {
      final result = await _remoteDataSource.getBlockById(blockId);
      return Right(result);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }

  @override
  ResultFuture<List<Room>> getBlockRooms(String blockId) async {
    try {
      final result = await _remoteDataSource.getBlockRooms(blockId);
      return Right(result);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }
}
