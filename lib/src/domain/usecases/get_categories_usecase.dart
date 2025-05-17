import 'package:app_gastos_grupo_61/core/helpers/classes.dart';
import 'package:app_gastos_grupo_61/core/helpers/types.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/category.dart';
import 'package:app_gastos_grupo_61/src/domain/repository/category_repository.dart';

class GetCategoriesUsecase extends UseCaseWithoutParams<List<Category>> {
  final CategoryRepository repository;

  GetCategoriesUsecase({required this.repository});

  @override
  ResultFuture<List<Category>> call() {
    return repository.getCategories();
  }
}