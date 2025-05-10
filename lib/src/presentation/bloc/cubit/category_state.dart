import 'package:app_gastos_grupo_61/src/domain/entities/category.dart';

enum CategoryStatus { initial, loading, loaded, error }

class CategoryState {
  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categories = const [],
    this.errorMessage,
  });

  final CategoryStatus status;
  final List<Category> categories;
  final String? errorMessage;

  CategoryState copyWith({
    CategoryStatus? status,
    List<Category>? categories,
    String? errorMessage,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
