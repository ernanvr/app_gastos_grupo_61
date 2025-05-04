import 'package:app_gastos_grupo_61/src/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({required super.id, required super.name});

  factory CategoryModel.fromEntity(Category entity) {
    return CategoryModel(id: entity.id, name: entity.name);
  }
}
