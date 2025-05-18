import 'package:app_gastos_grupo_61/core/errors/failure.dart';
import 'package:app_gastos_grupo_61/core/helpers/classes.dart';
import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/budget.dart';
import 'package:app_gastos_grupo_61/src/domain/repository/budget_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateBudgetUseCase extends UseCaseWithParams<int, Budget> {
  final BudgetRepository repository;

  UpdateBudgetUseCase(this.repository);

  @override
  ResultFuture<int> call(Budget budget) async {
    try {
      if (budget.id == null) {
        throw ValidationError(
          message: "El presupuesto debe contar con un id.",
          statusCode: 400,
        );
      }

      if (budget.initialAmount <= 0) {
        throw ValidationError(
          message: "El presupuesto debe ser mayor de cero.",
          statusCode: 400,
        );
      }

      final response = await repository.getBudgetById(budget.id!);
      print('Response from UpdateBudgetUsecase, getBudgetById');
      print(response);
      final oldBudget = response.fold((f) => throw f, (oldBudget) => oldBudget);

      final newBalanceIsGreaterThanZero =
          budget.initialAmount - oldBudget.initialAmount + oldBudget.balance >=
              0;

      if (!newBalanceIsGreaterThanZero) {
        throw ValidationError(
          message: "Balance de presupuesto es menor a cero.",
          statusCode: 400,
        );
      }

      return repository.updateBudget(budget);
    } catch (e) {
      if (e is ValidationError) {
        return left(e);
      } else if (e is Failure) {
        return left(e);
      }
      return left(
        Failure(
          message: 'Un error desconocido ha ocurrido en UpdateBudgetUseCase',
          statusCode: 400,
        ),
      );
    }
  }
}
