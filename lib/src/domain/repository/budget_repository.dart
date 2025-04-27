import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/budget.dart';

abstract class BudgetRepository {
  const BudgetRepository();

  ResultFuture<List<Budget>> getBudgets();

  ResultFuture<Budget> getBudgetById(int id);

  ResultFuture<int> insertBudget(Budget budget);

  ResultFuture<int> updateBudget(Budget budget);

  ResultFuture<int> deleteBudget(Budget budget);
}
