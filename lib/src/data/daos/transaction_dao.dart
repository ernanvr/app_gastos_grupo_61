import 'package:app_gastos_grupo_61/src/data/models/transaction_model.dart';
import 'package:app_gastos_grupo_61/src/data/models/transaction_with_category_model.dart';
import 'package:floor/floor.dart';

@dao
abstract class TransactionDao {
  @Query('Select * from transaction_with_category WHERE budgetId = :id')
  Future<List<TransactionWithCategoryModel>> getTransactionsByBudgetId(int id);

  @insert
  Future<int> insertTransaction(TransactionModel transaction);

  @update
  Future<int> updateTransaction(TransactionModel transaction);

  @delete
  Future<int> deleteTransaction(TransactionModel transaction);
}
