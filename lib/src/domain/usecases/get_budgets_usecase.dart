import 'package:app_gastos_grupo_61/core/helpers/classes.dart';
import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/budget.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/budget_with_balance.dart';
import 'package:app_gastos_grupo_61/src/domain/repository/budget_repository.dart';

class GetBudgetsUsecase extends UseCaseWithoutParams<List<Budget>> {
  final BudgetRepository repository;

  GetBudgetsUsecase({required this.repository});

  @override
  ResultFuture<List<BudgetWithBalance>> call() {
    return repository.getBudgets();
  }
}
