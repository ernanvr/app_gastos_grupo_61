import 'package:app_gastos_grupo_61/src/domain/entities/transaction_with_category.dart';
import 'package:floor/floor.dart';

@DatabaseView('''
  SELECT
      T.id,
      T.categoryId,
      C.name AS categoryName, -- Seleccionamos el nombre de la categoría y lo renombramos
      T.budgetId,
      T.description,
      T.amount,
      T.date,
      T.isIncome
  FROM
      transaction AS T -- Tabla de transacciones (alias T)
  INNER JOIN
      category AS C ON T.categoryId = C.id; -- Unimos con la tabla de categorías (alias C) donde el ID de la categoría coincide con el categoryId de la transacción. Usamos INNER JOIN porque una transacción debe tener una categoría asociada para aparecer en esta vista.
  ''', viewName: 'transaction_with_category')
class TransactionWithCategoryModel extends TransactionWithCategory {
  const TransactionWithCategoryModel({
    super.id,
    required super.categoryId,
    super.categoryName,
    required super.budgetId,
    required super.description,
    required super.amount,
    required super.date,
    required super.isIncome,
  });
}
