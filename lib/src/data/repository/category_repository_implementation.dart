import 'package:app_gastos_grupo_61/core/errors/failure.dart';
import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/data/daos/category_dao.dart';
import 'package:app_gastos_grupo_61/src/data/models/category_model.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/category.dart';
import 'package:app_gastos_grupo_61/src/domain/repository/category_repository.dart';
import 'package:dartz/dartz.dart';

class CategoryRepositoryImplementation implements CategoryRepository {
  final CategoryDao localDatasource;

  CategoryRepositoryImplementation({required this.localDatasource});

  @override
  ResultFuture<List<Category>> getCategories() async {
    try {
      final response = await localDatasource.getCategories();

      return right(response);
    } catch (e) {
      return left(LocalDatabaseFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<int> insertCategory(Category category) async {
    try {
      final model = CategoryModel.fromEntity(category);
      final response = await localDatasource.insertCategory(model);

      return right(response);
    } catch (e) {
      return left(LocalDatabaseFailure(message: e.toString(), statusCode: 500));
    }
  }
}
