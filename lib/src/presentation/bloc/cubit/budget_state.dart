import 'package:app_gastos_grupo_61/src/domain/entities/budget.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/budget_with_balance.dart';

enum BudgetStatus { initial, loading, loaded, error }

class BudgetState {
  const BudgetState({
    this.status = BudgetStatus.initial,
    this.budgets = const [],
    this.errorMessage,
    this.selectedBudget,
  });

  final BudgetStatus status;
  final List<Budget> budgets;
  final String? errorMessage;
  final BudgetWithBalance? selectedBudget;

  BudgetState copyWith({
    BudgetStatus? status,
    List<BudgetWithBalance>? budgets,
    String? errorMessage,
    BudgetWithBalance? selectedBudget,
  }) {
    return BudgetState(
      status: status ?? this.status,
      budgets: budgets ?? this.budgets,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedBudget: selectedBudget ?? this.selectedBudget,
    );
  }
}
