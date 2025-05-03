import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/category.dart';

abstract class CategoryRepository {
  const CategoryRepository();

  ResultFuture<List<Category>> getCategories();

  ResultFuture<Category> getCategoryById(int id);

  ResultFuture<int> insertCategory(Category category);

  ResultFuture<int> updateCategory(Category category);

  ResultFuture<int> deleteCategory(Category category);
}
