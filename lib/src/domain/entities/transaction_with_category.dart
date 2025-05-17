import 'package:app_gastos_grupo_61/src/domain/entities/transaction.dart';

class TransactionWithCategory extends Transaction {
  final String categoryName;

  const TransactionWithCategory({
    super.id,
    required super.categoryId,
    required this.categoryName,
    required super.budgetId,
    required super.description,
    required super.amount,
    required super.date,
    required super.isIncome,
  });

  @override
  List<Object?> get props => [
    id,
    categoryId,
    categoryName,
    description,
    amount,
    date,
    isIncome,
  ];
}
