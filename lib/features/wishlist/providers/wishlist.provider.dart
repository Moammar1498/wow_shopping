import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';
import 'package:wow_shopping/models/product_item.dart';

class SelectWishListItemNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    return {};
  }

  void setSelected(ProductItem item, bool selected) {
    final selectedItems = {...state};
    if (selected) {
      selectedItems.add(item.id);
    } else {
      selectedItems.remove(item.id);
    }
  }

  void toggleSelectAll() {
    final wishlistItems = ref.read(wishlistRepoProvider).currentWishlistItems;
    final allIds = wishlistItems.map((el) => el.id).toList();
    final selectedItems = {...state};
    if (selectedItems.containsAll(allIds)) {
      selectedItems.clear();
    } else {
      selectedItems.addAll(allIds);
    }
  }

  void removeSelected() {
    final selectedItems = {...state};
    for (final selected in selectedItems) {
      ref.read(wishlistRepoProvider).removeToWishlist(selected);
    }
    selectedItems.clear();
  }

  void onTogglePressed(bool value, ProductItem item) {
    if (value) {
      ref.read(wishlistRepoProvider).addToWishlist(item.id);
    } else {
      ref.read(wishlistRepoProvider).removeToWishlist(item.id);
    }
  }
}

final wishlistSelectedItemsProvider =
    NotifierProvider<SelectWishListItemNotifier, Set<String>>(
        () => SelectWishListItemNotifier());
