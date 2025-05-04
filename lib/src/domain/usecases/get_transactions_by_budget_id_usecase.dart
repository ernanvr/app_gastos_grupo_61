import 'package:app_gastos_grupo_61/core/helpers/classes.dart';
import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction.dart';
import 'package:app_gastos_grupo_61/src/domain/repository/transaction_repository.dart';

class GetTransactionsByBudgetIdUsecase
    extends UseCaseWithParams<List<Transaction>, int> {
  final TransactionRepository repository;

  GetTransactionsByBudgetIdUsecase({required this.repository});

  @override
  ResultFuture<List<Transaction>> call(int id) {
    return repository.getTransactionsByBudgetId(id);
  }
}
