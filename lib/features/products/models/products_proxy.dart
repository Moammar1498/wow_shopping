import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/backend/wishlist.repo.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/utils/formatting.dart';

class ProductProxy extends ChangeNotifier {
  ProductProxy(this.productItem, [this.onWishList = false]) {
    toggleWishListCommand = Command.createAsyncNoParamNoResult(() async {
      onWishList = !onWishList;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));
      if (onWishList) {
        di<WishlistRepo>().addToWishlist(productItem.id);
      } else {
        di<WishlistRepo>().removeToWishlist(productItem.id);
      }
      throw Exception('Failed to add to wishlist');
      // TODO: add to the wishlist
    },
        errorFilter: const ErrorHandlerLocalAndGlobal(),
        debugName: 'toggleWishListCommand');

    toggleWishListCommand.errors.listen((err, _) {
      onWishList = onWishList;
      notifyListeners();
    });
  }

  late Command<void, void> toggleWishListCommand;

  bool onWishList;

  final ProductItem productItem;

  String get id => productItem.id;
  String get category => productItem.category;
  String get title => productItem.title;
  String get subTitle => productItem.subTitle;
  Decimal get price => productItem.price;
  Decimal get priceWithTax => productItem.priceWithTax;
  List<String> get photos => productItem.photos;
  String get description => productItem.description;

  String get primaryPhoto => photos[0];

  String get formattedPrice => formatCurrency(price);

  String get formattedPriceWithTax => formatCurrency(priceWithTax);
}