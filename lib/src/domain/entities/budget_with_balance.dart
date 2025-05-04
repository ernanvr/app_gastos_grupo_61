import 'package:app_gastos_grupo_61/src/domain/entities/budget.dart';

class BudgetWithBalance extends Budget {
  const BudgetWithBalance({
    super.id,
    required super.description,
    required super.initialAmount,
    required super.date,
    required this.balance,
  });

  final double balance;

  @override
  List<Object?> get props => [id, description, initialAmount, balance, date];
}
