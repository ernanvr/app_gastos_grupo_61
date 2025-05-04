import 'package:app_gastos_grupo_61/src/data/models/budget_model.dart';
import 'package:app_gastos_grupo_61/src/data/models/budget_with_balance_model.dart';
import 'package:floor/floor.dart';

@dao
abstract class BudgetDao {
  @Query('Select * from budget')
  Future<List<BudgetWithBalanceModel>> getBudgets();

  @Query('Select * from budget WHERE id = :id')
  Future<BudgetWithBalanceModel?> getBudgetById(int id);

  @insert
  Future<int> insertBudget(BudgetModel budget);

  @update
  Future<int> updateBudget(BudgetModel budget);

  @delete
  Future<int> deleteBudget(BudgetModel budget);
}
