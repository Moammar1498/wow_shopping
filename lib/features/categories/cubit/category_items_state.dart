part of 'category_items_cubit.dart';

@immutable
class CategoryItemsState {
  final CategoryItem selectedItem;
  const CategoryItemsState({this.selectedItem = CategoryItem.global});
}
