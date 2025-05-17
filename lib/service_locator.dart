import 'package:app_gastos_grupo_61/src/domain/usecases/delete_transaction_usecase.dart';
import 'package:app_gastos_grupo_61/src/domain/usecases/get_categories_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:app_gastos_grupo_61/src/data/datasources/floor/database.dart';
import 'package:app_gastos_grupo_61/src/data/repository/budget_repository_implementation.dart';
import 'package:app_gastos_grupo_61/src/data/repository/category_repository_implementation.dart';
import 'package:app_gastos_grupo_61/src/data/repository/transaction_repository_implementation.dart';
import 'package:app_gastos_grupo_61/src/domain/repository/budget_repository.dart';
import 'package:app_gastos_grupo_61/src/domain/repository/category_repository.dart';
import 'package:app_gastos_grupo_61/src/domain/repository/transaction_repository.dart';
import 'package:app_gastos_grupo_61/src/domain/usecases/delete_budget_usecase.dart';
import 'package:app_gastos_grupo_61/src/domain/usecases/get_budgets_usecase.dart';
import 'package:app_gastos_grupo_61/src/domain/usecases/get_transactions_by_budget_id_usecase.dart';
import 'package:app_gastos_grupo_61/src/domain/usecases/insert_budget_usecase.dart';
import 'package:app_gastos_grupo_61/src/domain/usecases/insert_transaction_usecase.dart';
import 'package:app_gastos_grupo_61/src/domain/usecases/update_budget_usecase.dart';
import 'package:app_gastos_grupo_61/src/domain/usecases/update_transaction_usecase.dart';
import 'package:app_gastos_grupo_61/core/helpers/constants.dart';
import 'package:app_gastos_grupo_61/src/data/models/category_model.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/budget_cubit.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/category_cubit.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/transaction_cubit.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Database
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  sl.registerSingleton<AppDatabase>(database);

  // DAOs
  sl.registerLazySingleton(() => sl<AppDatabase>().budgetDao);
  sl.registerLazySingleton(() => sl<AppDatabase>().categoryDao);
  sl.registerLazySingleton(() => sl<AppDatabase>().transactionDao);

  // Add default categories if they don't exist
  final existingCategories = await database.categoryDao.getCategories();
  final existingCategoryNames =
      existingCategories.map((category) => category.name).toList();

  for (var categoryName in defaultCategories) {
    if (!existingCategoryNames.contains(categoryName)) {
      await database.categoryDao.insertCategory(
        CategoryModel(name: categoryName),
      );
    }
  }

  // Repositories
  sl.registerLazySingleton<BudgetRepository>(
    () => BudgetRepositoryImplementation(localDatasource: sl()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImplementation(localDatasource: sl()),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImplementation(localDatasource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => DeleteBudgetUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetBudgetsUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => GetTransactionsByBudgetIdUsecase(repository: sl()),
  );
  sl.registerLazySingleton(() => InsertBudgetUsecase(repository: sl()));
  sl.registerLazySingleton(() => InsertTransactionUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateBudgetUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTransactionUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteTransactionUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetCategoriesUsecase(repository: sl()));

  // Blocs / Cubits
  sl.registerFactory(
    () => BudgetCubit(
      sl(), // GetBudgetsUsecase
      sl(), // InsertBudgetUsecase
      sl(), // UpdateBudgetUseCase
      sl(), // DeleteBudgetUsecase
    ),
  );
  sl.registerFactory(() => CategoryCubit(sl())); // GetCategoriesUsecase
  sl.registerFactory(
    () => TransactionCubit(
      sl(), // GetTransactionsByBudgetIdUsecase
      sl(), // InsertTransactionUseCase
      sl(), // UpdateTransactionUseCase
      sl(), // DeleteTransactionUsecase
    ),
  );
}
