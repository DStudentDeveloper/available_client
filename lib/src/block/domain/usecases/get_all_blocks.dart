import 'package:available/core/interfaces/usecase.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/block/domain/entities/block.dart';
import 'package:available/src/block/domain/repos/block_repo.dart';

class GetAllBlocks implements Usecase<List<Block>, NoParams> {
  const GetAllBlocks(this._repo);

  final BlockRepo _repo;

  @override
  ResultFuture<List<Block>> call(NoParams _) => _repo.getAllBlocks();
}
