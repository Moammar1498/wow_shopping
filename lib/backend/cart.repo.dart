import 'package:wow_shopping/features/products/models/products_proxy.dart';
import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/models/product_item.dart';

abstract class CartRepo {
  List<CartItem> get currentCartItems;
  Stream<List<CartItem>> get streamCartItems;

  bool cartContainsProduct(ProductProxy item);
  CartItem cartItemForProduct(ProductProxy item);

  void addToCart(ProductProxy item,
      {ProductOption option = ProductOption.none});
  void removeToCart(String productId);
}
