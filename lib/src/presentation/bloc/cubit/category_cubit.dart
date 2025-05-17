import 'package:app_gastos_grupo_61/src/domain/usecases/get_categories_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_state.dart'; // Assuming your state file is named this

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(this._getCategoriesUsecase) : super(const CategoryState());

  final GetCategoriesUsecase _getCategoriesUsecase;

  Future<void> loadCategories() async {
    try {
      emit(state.copyWith(status: CategoryStatus.loading));
      final categoriesResult = await _getCategoriesUsecase();
      categoriesResult.fold(
        (failure) => emit(state.copyWith(status: CategoryStatus.error, errorMessage: failure.message)),
        (categories) => emit(state.copyWith(status: CategoryStatus.loaded, categories: categories)),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CategoryStatus.error, errorMessage: e.toString()),
      );
    }
  }

  // Add methods for addCategory similarly if needed in the future
}
