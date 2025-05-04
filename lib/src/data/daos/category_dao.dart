import 'package:app_gastos_grupo_61/src/data/models/category_model.dart';
import 'package:floor/floor.dart';

@dao
abstract class CategoryDao {
  @Query('Select * from category')
  Future<List<CategoryModel>> getCategories();

  @insert
  Future<int> insertCategory(CategoryModel category);

  @delete
  Future<int> deleteCategory(CategoryModel category);
}
