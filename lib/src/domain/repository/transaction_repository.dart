import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction_with_category.dart';

abstract class TransactionRepository {
  const TransactionRepository();

  ResultFuture<List<TransactionWithCategory>> getTransactionsByBudgetId(int id);

  ResultFuture<int> insertTransaction(Transaction transaction);

  ResultFuture<int> updateTransaction(Transaction transaction);

  ResultFuture<int> deleteTransaction(Transaction transaction);

  ResultFuture<int> deleteTransactions(List<Transaction> transaction);
}
