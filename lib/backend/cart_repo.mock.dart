import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:wow_shopping/backend/cart.repo.dart';
import 'package:wow_shopping/features/products/models/products_proxy.dart';
import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/models/cart_storage.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:wow_shopping/models/product_item.dart';

/// FIXME: Very similar to the [WishlistRepo] and should be refactored out and simplified
class CartRepoMock implements CartRepo {
  late final File _file;
  late CartStorage _storage;
  late StreamController<List<CartItem>> _cartController;
  Timer? _saveTimer;

  Future<CartRepo> init() async {
    try {
      final dir = await path_provider.getApplicationDocumentsDirectory();
      final file = File(path.join(dir.path, 'cart.json'));
      if (await file.exists()) {
        _storage = CartStorage.fromJson(
          json.decode(await file.readAsString()),
        );
      } else {
        _storage = CartStorage.empty;
      }
      _cartController = StreamController<List<CartItem>>.broadcast(
        onListen: () => _emitCart(),
      );
      return this;
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      rethrow;
    }
  }

  void _emitCart() {
    _cartController.add(currentCartItems);
  }

  @override
  List<CartItem> get currentCartItems => _storage.items;

  @override
  Stream<List<CartItem>> get streamCartItems => _cartController.stream;

  @override
  CartItem cartItemForProduct(ProductProxy item) {
    return _storage.items //
        .firstWhere((el) => el.product.id == item.id,
            orElse: () => CartItem.none);
  }

  @override
  bool cartContainsProduct(ProductProxy item) {
    return cartItemForProduct(item) != CartItem.none;
  }

  @override
  void addToCart(ProductProxy item,
      {ProductOption option = ProductOption.none}) {
    if (cartContainsProduct(item)) {
      // FIXME: increase quantity
      return;
    }
    _storage = _storage.copyWith(
      items: {
        ..._storage.items,
        CartItem(
          product: item.productItem,
          option: option,
          deliveryFee: Decimal.zero, // FIXME: where from?
          deliveryDate: DateTime.now(), // FIXME: where from?
          quantity: 1,
        ),
      },
    );
    _emitCart();
    _saveCart();
  }

  @override
  void removeToCart(String productId) {
    _storage = _storage.copyWith(
      items: _storage.items.where((el) => el.product.id != productId),
    );
    _emitCart();
    _saveCart();
  }

  void _saveCart() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      await _file.writeAsString(json.encode(_storage.toJson()));
    });
  }
}
