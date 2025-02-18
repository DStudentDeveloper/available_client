// This is a necessary interface.
// ignore_for_file: one_member_abstracts

import 'package:available/core/utils/typedefs.dart';

abstract interface class Usecase<Type, Params> {
  const Usecase();

  ResultFuture<Type> call(Params params);
}

class NoParams {
  const NoParams();
}
