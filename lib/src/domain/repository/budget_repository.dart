import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/budget.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/budget_with_balance.dart';

abstract class BudgetRepository {
  const BudgetRepository();

  ResultFuture<List<BudgetWithBalance>> getBudgets();

  ResultFuture<BudgetWithBalance> getBudgetById(int id);

  ResultFuture<int> insertBudget(Budget budget);

  ResultFuture<int> updateBudget(Budget budget);

  ResultFuture<int> deleteBudget(Budget budget);
}
