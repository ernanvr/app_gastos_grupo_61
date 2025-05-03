import 'package:app_gastos_grupo_61/core/helpers/classes.dart';
import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/domain/repository/budget_repository.dart';

class DeleteBudgetUsecase extends UseCaseWithParams<void, int> {
  final BudgetRepository repository;

  DeleteBudgetUsecase({required this.repository});

  @override
  ResultFuture<void> call(int params) {
    return repository.deleteBudget(params);
  }
}