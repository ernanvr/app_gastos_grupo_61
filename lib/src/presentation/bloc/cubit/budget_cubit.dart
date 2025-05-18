import 'package:app_gastos_grupo_61/src/domain/entities/budget.dart';
import 'package:app_gastos_grupo_61/src/domain/usecases/delete_budget_usecase.dart';
import 'package:app_gastos_grupo_61/src/domain/usecases/get_budgets_usecase.dart';
import 'package:app_gastos_grupo_61/src/domain/usecases/insert_budget_usecase.dart';
import 'package:app_gastos_grupo_61/src/domain/usecases/update_budget_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'budget_state.dart'; // Assuming your state file is named this

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit(
    this._getBudgetsUsecase,
    this._insertBudgetUsecase,
    this._updateBudgetUseCase,
    this._deleteBudgetUsecase,
  ) : super(const BudgetState());

  final GetBudgetsUsecase _getBudgetsUsecase;
  final InsertBudgetUsecase _insertBudgetUsecase;
  final UpdateBudgetUseCase _updateBudgetUseCase;
  final DeleteBudgetUsecase _deleteBudgetUsecase;

  Future<void> loadBudgets() async {
    try {
      print('Triggering loadBudgets()');
      emit(state.copyWith(status: BudgetStatus.loading));
      final budgets = await _getBudgetsUsecase();
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
      // Ideally, cubits depend on use cases, not repositories directly.
      final result = await _insertBudgetUsecase(budget);
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
      final result = await _updateBudgetUseCase(budget);
      result.fold(
        (failure) {
          print('Error at EditBudget');
          print(failure);
          emit(
            state.copyWith(
              status: BudgetStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (_) {
          // On successful update, reload budgets to update the list
          print('Triggering EditBudget');
          loadBudgets();
        },
      );
    } catch (e) {
      print('Error at EditBudget');
      print(e);
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
      final result = await _deleteBudgetUsecase(budget);
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: BudgetStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
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
