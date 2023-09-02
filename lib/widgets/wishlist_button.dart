import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';
import 'package:wow_shopping/features/wishlist/providers/wishlist.provider.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/widgets/app_icon.dart';

@immutable
class WishlistButton extends ConsumerWidget {
  final ProductItem item;
  const WishlistButton({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(wishlistStorageProvider).items.contains(item.id);
    return IconButton(
      onPressed: () {
        ref
            .read(wishlistSelectedItemsProvider.notifier)
            .onTogglePressed(!value, item);
      },
      icon: AppIcon(
        iconAsset: value //
            ? Assets.iconHeartFilled
            : Assets.iconHeartEmpty,
        color: value //
            ? AppTheme.of(context).appColor
            : const Color(0xFFD0D0D0),
      ),
    );
  }
}
