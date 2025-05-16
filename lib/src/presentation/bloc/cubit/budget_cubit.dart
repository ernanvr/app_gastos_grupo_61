import 'package:app_gastos_grupo_61/src/domain/entities/budget.dart';
import 'package:app_gastos_grupo_61/src/domain/repository/budget_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'budget_state.dart'; // Assuming your state file is named this

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit(this._budgetRepository) : super(const BudgetState());

  final BudgetRepository _budgetRepository;

  Future<void> loadBudgets() async {
    try {
      emit(state.copyWith(status: BudgetStatus.loading));
      final budgets = await _budgetRepository.getBudgets();
      budgets.fold(
        (failure) => emit(
          state.copyWith(
            status: BudgetStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (budgets) => emit(
          state.copyWith(
            status: BudgetStatus.loaded,
            budgets: budgets,
            selectedBudget: budgets.isNotEmpty ? budgets.first : null,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: BudgetStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> addBudget(Budget budget) async {
    try {
      emit(state.copyWith(status: BudgetStatus.loading));
      // Assuming an InsertBudgetUseCase exists and is available through the repository or injected
      // Since use cases are not explicitly in the cubit's constructor,
      // I will simulate calling them via the repository for now.
      // Ideally, cubits depend on use cases, not repositories directly.
      final result = await _budgetRepository.insertBudget(budget);
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: BudgetStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (_) {
          // On successful insertion, reload budgets to update the list
          loadBudgets();
        },
      );
    } catch (e) {
      emit(
        state.copyWith(status: BudgetStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> editBudget(Budget budget) async {
    try {
      emit(state.copyWith(status: BudgetStatus.loading));
      // Assuming an UpdateBudgetUseCase exists
      final result = await _budgetRepository.updateBudget(budget);
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: BudgetStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (_) {
          // On successful update, reload budgets to update the list
          loadBudgets();
        },
      );
    } catch (e) {
      emit(
        state.copyWith(status: BudgetStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> deleteBudget(Budget budget) async {
    try {
      emit(state.copyWith(status: BudgetStatus.loading));
      // Assuming a DeleteBudgetUsecase exists.
      // The responsibility of deleting associated transactions should be handled
      // within the domain layer (e.g., the Usecase or Repository implementation).
      final result = await _budgetRepository.deleteBudget(budget);
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: BudgetStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (_) {
          // On successful deletion, reload budgets to update the list
          loadBudgets();
        },
      );
    } catch (e) {
      emit(
        state.copyWith(status: BudgetStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
