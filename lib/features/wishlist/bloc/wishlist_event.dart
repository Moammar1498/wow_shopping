part of 'wishlist_bloc.dart';

@immutable
sealed class WishlistEvent {}

final class SelectItem extends WishlistEvent {
  final ProductItem item;
  final bool selected;

  SelectItem({required this.item, required this.selected});
}

final class SelectAll extends WishlistEvent {}

final class ListenWishlistStream extends WishlistEvent {}

final class UpdateWishlistItems extends WishlistEvent {
  final List<ProductItem> wishlistItems;

  UpdateWishlistItems({required this.wishlistItems});
}

final class RemoveSelected extends WishlistEvent {}
