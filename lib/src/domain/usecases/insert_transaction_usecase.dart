import 'package:app_gastos_grupo_61/core/helpers/classes.dart';
import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction.dart';
import 'package:app_gastos_grupo_61/src/domain/repository/transaction_repository.dart';

class InsertTransactionUseCase extends UseCaseWithParams<int, Transaction> {
  final TransactionRepository repository;

  InsertTransactionUseCase({required this.repository});

  @override
  ResultFuture<int> call(Transaction params) {
    return repository.insertTransaction(params);
  }
}
