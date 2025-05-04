import 'package:app_gastos_grupo_61/src/data/models/budget_model.dart';
import 'package:app_gastos_grupo_61/src/data/models/category_model.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction.dart';
import 'package:floor/floor.dart';

@Entity(
  tableName: 'transaction',
  primaryKeys: ['id'],
  foreignKeys: [
    ForeignKey(
      childColumns: ['categoryId'],
      parentColumns: ['id'],
      entity: CategoryModel,
    ),
    ForeignKey(
      childColumns: ['budgetId'],
      parentColumns: ['id'],
      entity: BudgetModel,
    ),
  ],
)
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

  factory TransactionModel.fromEntity(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      categoryId: entity.categoryId,
      budgetId: entity.budgetId,
      description: entity.description,
      amount: entity.amount,
      date: entity.date,
      isIncome: entity.isIncome,
    );
  }
}
