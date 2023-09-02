import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/models/product_item.dart';

class HomeNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    return {};
  }
}

final homeProvider =
    NotifierProvider<HomeNotifier, Set<String>>(() => HomeNotifier());

final topSellingProvider =
    FutureProvider.autoDispose<List<ProductItem>>((ref) async {
  final topSelling = await ref.read(productRepoProvider).fetchTopSelling();
  return topSelling;
});
