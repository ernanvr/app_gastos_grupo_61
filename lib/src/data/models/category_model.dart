import 'package:app_gastos_grupo_61/src/domain/entities/category.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'category', primaryKeys: ['id'])
class CategoryModel extends Category {
  const CategoryModel({super.id, required super.name});

  factory CategoryModel.fromEntity(Category entity) {
    return CategoryModel(id: entity.id, name: entity.name);
  }
}
