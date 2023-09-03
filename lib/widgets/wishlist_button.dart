import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/features/products/models/products_proxy.dart';
import 'package:wow_shopping/widgets/app_icon.dart';

@immutable
class WishlistButton extends StatelessWidget with WatchItMixin {
  const WishlistButton({
    super.key,
    required this.item,
  });

  final ProductProxy item;

  @override
  Widget build(BuildContext context) {
    final onWishlist = watch(item).onWishList;
    return IconButton(
      onPressed: item.toggleWishListCommand,
      icon: AppIcon(
        iconAsset: onWishlist //
            ? Assets.iconHeartFilled
            : Assets.iconHeartEmpty,
        color: onWishlist //
            ? AppTheme.of(context).appColor
            : const Color(0xFFD0D0D0),
      ),
    );
  }
}
