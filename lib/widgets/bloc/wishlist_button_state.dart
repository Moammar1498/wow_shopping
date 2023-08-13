part of 'wishlist_button_bloc.dart';

final class WishlistButtonState {
  const WishlistButtonState({required this.isWishlisted});
  final bool isWishlisted;

  WishlistButtonState copyWith(bool? isWishlisted) {
    return WishlistButtonState(isWishlisted: isWishlisted ?? this.isWishlisted);
  }
}
