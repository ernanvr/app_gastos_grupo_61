import 'package:app_gastos_grupo_61/core/errors/failure.dart';
import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/data/daos/budget_dao.dart';
import 'package:app_gastos_grupo_61/src/data/models/budget_model.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/budget.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/budget_with_balance.dart';
import 'package:app_gastos_grupo_61/src/domain/repository/budget_repository.dart';
import 'package:dartz/dartz.dart';

class BudgetRepositoryImplementation implements BudgetRepository {
  final BudgetDao localDatasource;

  BudgetRepositoryImplementation({required this.localDatasource});

  @override
  ResultFuture<List<BudgetWithBalance>> getBudgets() async {
    try {
      final response = await localDatasource.getBudgets();

      return right(response);
    } catch (e) {
      return left(LocalDatabaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<BudgetWithBalance> getBudgetById(int id) async {
    try {
      final response = await localDatasource.getBudgetById(id);

      if (response == null) {
        throw NotFound();
      }

      return right(response);
    } catch (e) {
      return left(LocalDatabaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<int> insertBudget(Budget budget) async {
    try {
      final model = BudgetModel.fromEntity(budget);

      final response = await localDatasource.insertBudget(model);

      return right(response);
    } catch (e) {
      return left(LocalDatabaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<int> updateBudget(Budget budget) async {
    try {
      final model = BudgetModel.fromEntity(budget);

      final response = await localDatasource.updateBudget(model);

      return right(response);
    } catch (e) {
      return left(LocalDatabaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<int> deleteBudget(Budget budget) async {
    try {
      final model = BudgetModel.fromEntity(budget);

      final response = await localDatasource.deleteBudget(model);

      return right(response);
    } catch (e) {
      return left(LocalDatabaseFailure(message: e.toString(), statusCode: 500));
    }
  }
}
