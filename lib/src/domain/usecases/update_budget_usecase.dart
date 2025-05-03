import 'package:app_gastos_grupo_61/core/helpers/classes.dart';
import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/budget.dart';
import 'package:app_gastos_grupo_61/src/domain/repository/budget_repository.dart';

class UpdateBudgetUseCase {
  final BudgetRepository repository;

  UpdateBudgetUseCase(this.repository);

  Future<void> call(Budget budget) async {
    // Aquí puedes añadir validaciones
    if (budget.amount < 0) {
      throw Exception("El monto del presupuesto no puede ser negativo.");
    }

    await repository.updateBudget(budget);
  }
}