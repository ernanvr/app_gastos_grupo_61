import 'package:app_gastos_grupo_61/src/domain/entities/budget.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'budget', primaryKeys: ['id'])
class BudgetModel extends Budget {
  const BudgetModel({
    super.id,
    required super.description,
    required super.initialAmount,
    required super.date,
  });

  factory BudgetModel.fromEntity(Budget entity) {
    return BudgetModel(
      id: entity.id,
      description: entity.description,
      initialAmount: entity.initialAmount,
      date: entity.date,
    );
  }
}
