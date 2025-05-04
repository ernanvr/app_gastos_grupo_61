import 'package:app_gastos_grupo_61/src/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    super.id,
    required super.categoryId,
    required super.budgetId,
    required super.description,
    required super.amount,
    required super.date,
    required super.isIncome,
  });
}
