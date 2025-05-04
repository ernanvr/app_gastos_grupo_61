import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction.dart';

abstract class TransactionRepository {
  const TransactionRepository();

  ResultFuture<List<Transaction>> getTransactions();

  ResultFuture<List<Transaction>> getTransactionsByBudgetId(int id);

  ResultFuture<Transaction> getTransactionById(int id);

  ResultFuture<int> insertTransaction(Transaction transaction);

  ResultFuture<int> updateTransaction(Transaction transaction);

  ResultFuture<int> deleteTransaction(Transaction transaction);
}
