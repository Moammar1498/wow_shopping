part of 'wishlist_bloc.dart';

@immutable
final class WishlistState {
  final List<ProductItem> wishlistItems;
  final Set<String> selectedItems;

  const WishlistState({
    this.wishlistItems = const <ProductItem>[],
    this.selectedItems = const <String>{},
  });

  WishlistState copyWith(
      {List<ProductItem>? wishlistItems, Set<String>? selectedItems}) {
    return WishlistState(
      wishlistItems: wishlistItems ?? this.wishlistItems,
      selectedItems: selectedItems ?? this.selectedItems,
    );
  }
}
