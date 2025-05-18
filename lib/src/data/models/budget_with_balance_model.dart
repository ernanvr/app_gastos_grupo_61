import 'package:app_gastos_grupo_61/src/domain/entities/budget_with_balance.dart';
import 'package:floor/floor.dart';

@DatabaseView('''
  SELECT
      B.id,
      B.description,
      B.initialAmount,
      B.date,
      B.initialAmount + COALESCE(SUM(CASE WHEN C.isIncome = 1 THEN T.amount ELSE -T.amount END), 0) AS balance
  FROM
      budget AS B
  LEFT JOIN
      transactions AS T ON B.id = T.budgetId
  LEFT JOIN
      category AS C ON T.categoryId = C.id
  GROUP BY
      B.id, B.description, B.initialAmount, B.date;
  ''', viewName: 'budget_with_balance')
class BudgetWithBalanceModel extends BudgetWithBalance {
  const BudgetWithBalanceModel({
    super.id,
    required super.description,
    required super.initialAmount,
    required super.date,
    required super.balance,
  });
}
