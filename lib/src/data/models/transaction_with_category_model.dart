import 'package:app_gastos_grupo_61/src/domain/entities/transaction_with_category.dart';
import 'package:floor/floor.dart';

@DatabaseView('SELECT *', viewName: 'transaction_with_category')
class TransactionWithCategoryModel extends TransactionWithCategory {
  const TransactionWithCategoryModel({
    super.id,
    required super.categoryId,
    super.categoryName,
    required super.budgetId,
    required super.description,
    required super.amount,
    required super.date,
    required super.isIncome,
  });
}
