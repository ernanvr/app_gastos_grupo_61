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
        (budgets) =>
            emit(state.copyWith(status: BudgetStatus.loaded, budgets: budgets)),
      );
    } catch (e) {
      emit(
        state.copyWith(status: BudgetStatus.error, errorMessage: e.toString()),
      );
    }
  }

  // Add methods for addBudget, editBudget, deleteBudget similarly
}
