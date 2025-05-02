import 'package:app_gastos_grupo_61/core/helpers/classes.dart';
import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/budget.dart';
import 'package:app_gastos_grupo_61/src/domain/repository/budget_repository.dart';

class InsertBudgetUsecase extends UseCaseWithParams<int, Budget> {
  final BudgetRepository repository;

  InsertBudgetUsecase({required this.repository});

  @override
  ResultFuture<int> call(params) {
    return repository.insertBudget(params);
  }
}
