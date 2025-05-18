import 'package:app_gastos_grupo_61/core/helpers/classes.dart';
import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction.dart';
import 'package:app_gastos_grupo_61/src/domain/repository/transaction_repository.dart';

class DeleteTransactionsUsecase
    extends UseCaseWithParams<int, List<Transaction>> {
  final TransactionRepository repository;

  DeleteTransactionsUsecase({required this.repository});

  @override
  ResultFuture<int> call(List<Transaction> params) {
    return repository.deleteTransactions(params);
  }
}
