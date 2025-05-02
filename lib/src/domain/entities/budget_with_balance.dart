import 'package:app_gastos_grupo_61/src/domain/entities/budget.dart';

class BudgetWithBalance extends Budget {
  const BudgetWithBalance({
    required super.description,
    required super.initialAmount,
    required super.date,
    this.balance,
  });

  final double? balance;

  @override
  List<Object?> get props => [id, description, initialAmount, balance, date];
}
