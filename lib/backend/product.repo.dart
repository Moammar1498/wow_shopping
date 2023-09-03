import 'package:wow_shopping/features/products/models/products_proxy.dart';

abstract class ProductsRepo {
  List<ProductProxy> get cachedItems;
  Future<List<ProductProxy>> fetchTopSelling();

  //Find product from the top level Products cached
  ProductProxy findProduct(String id);
}
