import 'package:flutter_command/flutter_command.dart';
import 'package:wow_shopping/backend/cart.repo.dart';
import 'package:wow_shopping/backend/cart_repo.mock.dart';
import 'package:wow_shopping/backend/product.repo.dart';
import 'package:wow_shopping/backend/product_repo.mock.dart';
import 'package:wow_shopping/backend/wishlist.repo.dart';
import 'package:wow_shopping/backend/wishlist_repo.mock.dart';
import 'package:wow_shopping/utils/command_error_filters.dart';
import 'package:watch_it/watch_it.dart';

void setup() {
  di.registerSingleton(InteractionManager());
  di.registerSingletonAsync<ProductsRepo>(() => ProductsRepoMock().init());
  di.registerSingletonAsync<WishlistRepo>(() => WishlistRepoMock().init(),
      dependsOn: [ProductsRepo]);
  di.registerSingletonAsync<CartRepo>(() => CartRepoMock().init(),
      dependsOn: [ProductsRepo]);

  Command.globalExceptionHandler = (error, stackTrace) {
    di<InteractionManager>().showMessage(error.toString());
  };
}
