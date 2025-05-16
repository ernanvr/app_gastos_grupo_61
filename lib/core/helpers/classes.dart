import '../helpers/types.dart';

abstract class UseCaseWithParams<ReturnType, Params> {
  ResultFuture<ReturnType> call(Params params);
}

abstract class UseCaseWithoutParams<Type> {
  ResultFuture<Type> call();
}

class PieChartValue {
  String categoryName;
  int qty;

  PieChartValue(this.categoryName, this.qty);
}
