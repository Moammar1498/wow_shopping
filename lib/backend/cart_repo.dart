import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/models/cart_storage.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';

final cartStorageProvider = StateProvider<CartStorage>((ref) {
  return const CartStorage(items: []);
});

final cartRepoProvider = Provider<CartRepo>((ref) {
  return CartRepo._(ref);
});

/// FIXME: Very similar to the [WishlistRepo] and should be refactored out and simplified

class CartRepo {
  CartRepo._(this.ref);

  final Ref ref;
  late final File _file;
  Timer? _saveTimer;

  Future<void> create() async {
    CartStorage storage;
    try {
      final dir = await path_provider.getApplicationDocumentsDirectory();
      final file = File(path.join(dir.path, 'cart.json'));
      if (await file.exists()) {
        storage = CartStorage.fromJson(
          json.decode(await file.readAsString()),
        );
      } else {
        storage = CartStorage.empty;
      }
      ref.read(cartStorageProvider.notifier).update((state) => storage);
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      rethrow;
    }
  }

  List<CartItem> get currentCartItems => ref.read(cartStorageProvider).items;

  CartItem cartItemForProduct(ProductItem item) {
    return ref
        .read(cartStorageProvider)
        .items //
        .firstWhere((el) => el.product.id == item.id,
            orElse: () => CartItem.none);
  }

  bool cartContainsProduct(ProductItem item) {
    return cartItemForProduct(item) != CartItem.none;
  }

  void addToCart(ProductItem item,
      {ProductOption option = ProductOption.none}) {
    final cartItems = ref.read(cartStorageProvider);
    if (cartContainsProduct(item)) {
      // FIXME: increase quantity
      return;
    }
    final updatedCart = cartItems.copyWith(
      items: {
        ...cartItems.items,
        CartItem(
          product: item,
          option: option,
          deliveryFee: Decimal.zero, // FIXME: where from?
          deliveryDate: DateTime.now(), // FIXME: where from?
          quantity: 1,
        ),
      },
    );
    ref.read(cartStorageProvider.notifier).update((state) => updatedCart);
    _saveCart();
  }

  void removeToCart(String productId) {
    final cartItems = ref.read(cartStorageProvider);
    final updatedCart = cartItems.copyWith(
      items: cartItems.items.where((el) => el.product.id != productId),
    );
    ref.read(cartStorageProvider.notifier).update((state) => updatedCart);
    _saveCart();
  }

  void _saveCart() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      await _file
          .writeAsString(json.encode(ref.read(cartStorageProvider).toJson()));
    });
  }
}
