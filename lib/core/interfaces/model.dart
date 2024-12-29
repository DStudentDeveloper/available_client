import 'package:available/core/utils/typedefs.dart';

abstract interface class Model {
  const Model();

  DataMap toMap();

  Model copyWith();
}
