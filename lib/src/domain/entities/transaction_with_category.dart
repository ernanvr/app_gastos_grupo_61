import 'package:app_gastos_grupo_61/src/domain/entities/transaction.dart';

class TransactionWithCategory extends Transaction {
  final String categoryName;
  final bool isIncome;

  const TransactionWithCategory({
    super.id,
    required super.categoryId,
    required this.categoryName,
    required this.isIncome,
    required super.budgetId,
    required super.description,
    required super.amount,
    required super.date,
  });

  @override
  List<Object?> get props => [
    id,
    categoryId,
    categoryName,
    isIncome,
    description,
    amount,
    date,
  ];
}
