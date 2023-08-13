// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wow_shopping/models/category_item.dart';

part 'category_items_state.dart';

class CategoryItemsCubit extends Cubit<CategoryItemsState> {
  CategoryItemsCubit() : super(const CategoryItemsState());

  void onCategoryItemPressed(CategoryItem item) {
    emit(CategoryItemsState(selectedItem: item));
  }
}
