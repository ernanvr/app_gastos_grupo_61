import 'package:app_gastos_grupo_61/core/utils/datetime_converter.dart';
import 'package:app_gastos_grupo_61/src/data/daos/budget_dao.dart';
import 'package:app_gastos_grupo_61/src/data/daos/category_dao.dart';
import 'package:app_gastos_grupo_61/src/data/daos/transaction_dao.dart';
import 'package:app_gastos_grupo_61/src/data/models/budget_model.dart';
import 'package:app_gastos_grupo_61/src/data/models/budget_with_balance_model.dart';
import 'package:app_gastos_grupo_61/src/data/models/category_model.dart';
import 'package:app_gastos_grupo_61/src/data/models/transaction_model.dart';
import 'package:app_gastos_grupo_61/src/data/models/transaction_with_category_model.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';
import 'package:floor/floor.dart';

part 'database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(
  version: 1,
  entities: [BudgetModel, CategoryModel, TransactionModel],
  views: [BudgetWithBalanceModel, TransactionWithCategoryModel],
)
abstract class AppDatabase extends FloorDatabase {
  BudgetDao get budgetDao;
  TransactionDao get transactionDao;
  CategoryDao get categoryDao;
}
