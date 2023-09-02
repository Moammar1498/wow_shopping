import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:wow_shopping/models/wishlist_storage.dart';

final wishlistRepoProvider = Provider<WishlistRepo>((ref) {
  return WishlistRepo._(ref);
});

final wishlistStorageProvider = StateProvider<WishlistStorage>((ref) {
  return const WishlistStorage(items: {});
});

class WishlistRepo {
  WishlistRepo._(this.ref);

  final Ref ref;
  late final File _file;
  Timer? _saveTimer;

  Future<void> create() async {
    WishlistStorage wishlist;
    try {
      final dir = await path_provider.getApplicationDocumentsDirectory();
      final file = File(path.join(dir.path, 'wishlist.json'));
      if (await file.exists()) {
        wishlist = WishlistStorage.fromJson(
          json.decode(await file.readAsString()),
        );
      } else {
        wishlist = WishlistStorage.empty;
      }
      ref.read(wishlistStorageProvider.notifier).update((state) => wishlist);
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      rethrow;
    }
  }

  List<ProductItem> get currentWishlistItems => ref
      .read(wishlistStorageProvider)
      .items
      .map(ref.read(productRepoProvider).findProduct)
      .toList();

  void addToWishlist(String productId) {
    final wishlist = ref.read(wishlistStorageProvider);
    if (wishlist.items.contains(productId)) {
      return;
    }
    final updatedWishlist = wishlist.copyWith(
      items: {...wishlist.items, productId},
    );
    ref
        .read(wishlistStorageProvider.notifier)
        .update((state) => updatedWishlist);
    _saveWishlist();
  }

  void removeToWishlist(String productId) {
    final wishlist = ref.read(wishlistStorageProvider);
    final updatedWishlist = wishlist.copyWith(
      items: wishlist.items.where((el) => el != productId),
    );
    ref
        .read(wishlistStorageProvider.notifier)
        .update((state) => updatedWishlist);
    _saveWishlist();
  }

  void _saveWishlist() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      await _file.writeAsString(
          json.encode(ref.read(wishlistStorageProvider).toJson()));
    });
  }
}
