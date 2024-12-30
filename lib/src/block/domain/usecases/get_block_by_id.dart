import 'package:available/core/interfaces/usecase.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/block/domain/entities/block.dart';
import 'package:available/src/block/domain/repos/block_repo.dart';

class GetBlockById implements Usecase<Block, String> {
  const GetBlockById(this._repo);

  final BlockRepo _repo;

  @override
  ResultFuture<Block> call(String params) => _repo.getBlockById(params);
}
