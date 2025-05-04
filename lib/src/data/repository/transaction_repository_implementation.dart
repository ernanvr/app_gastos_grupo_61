import 'package:app_gastos_grupo_61/core/errors/failure.dart';
import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/data/daos/transaction_dao.dart';
import 'package:app_gastos_grupo_61/src/data/models/transaction_model.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction_with_category.dart';
import 'package:app_gastos_grupo_61/src/domain/repository/transaction_repository.dart';
import 'package:dartz/dartz.dart';

class TransactionRepositoryImplementation implements TransactionRepository {
  final TransactionDao localDatasource;

  TransactionRepositoryImplementation({required this.localDatasource});

  @override
  ResultFuture<List<TransactionWithCategory>> getTransactionsByBudgetId(
    int id,
  ) async {
    try {
      final response = await localDatasource.getTransactionsByBudgetId(id);

      return right(response);
    } catch (e) {
      return left(LocalDatabaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<int> insertTransaction(Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);

      final response = await localDatasource.insertTransaction(model);

      return right(response);
    } catch (e) {
      return left(LocalDatabaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<int> updateTransaction(Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);

      final response = await localDatasource.updateTransaction(model);

      return right(response);
    } catch (e) {
      return left(LocalDatabaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<int> deleteTransaction(Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);

      final response = await localDatasource.deleteTransaction(model);

      return right(response);
    } catch (e) {
      return left(LocalDatabaseFailure(message: e.toString(), statusCode: 500));
    }
  }
}
