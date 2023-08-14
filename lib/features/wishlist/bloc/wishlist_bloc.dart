// ignore_for_file: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/models/product_item.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc(WishlistRepo wishlistRepo)
      : _wishlistRepo = wishlistRepo,
        super(const WishlistState()) {
    on<SelectItem>(_selectItem);
    on<SelectAll>(_selectAll);
    on<RemoveSelected>(_removeSelectedItem);
    on<ListenWishlistStream>(_listenToWishlist);
    on<UpdateWishlistItems>(_onUpdateWishlistItems);

    // _wishlistItemsSubscription =
    //     wishlistRepo.streamWishlistItems.listen((items) {
    //   add(UpdateWishlistItems(wishlistItems: items));
    // });
  }

  final WishlistRepo _wishlistRepo;
  // late final StreamSubscription<List<ProductItem>> _wishlistItemsSubscription;

  void _listenToWishlist(
      ListenWishlistStream event, Emitter<WishlistState> emit) async {
    await emit.onEach(_wishlistRepo.streamWishlistItems, onData: (wishedItems) {
      add(UpdateWishlistItems(wishlistItems: wishedItems));
    });
  }

  void _selectItem(SelectItem event, Emitter<WishlistState> emit) async {
    if (event.selected) {
      emit(state.copyWith(
        selectedItems: Set.from(state.selectedItems)..add(event.item.id),
      ));
    } else {
      emit(state.copyWith(
          selectedItems: Set.from(state.selectedItems)..remove(event.item.id)));
    }
  }

  void _selectAll(SelectAll event, Emitter<WishlistState> emit) async {
    final allIds = state.wishlistItems.map((el) => el.id).toList();
    if (state.selectedItems.containsAll(allIds)) {
      emit(state.copyWith(
          selectedItems: Set.from(state.selectedItems)..removeAll(allIds)));
    } else {
      emit(state.copyWith(
          selectedItems: Set.from(state.selectedItems)..addAll(allIds)));
    }
  }

  void _removeSelectedItem(
      RemoveSelected event, Emitter<WishlistState> emit) async {
    for (final selected in state.selectedItems) {
      _wishlistRepo.removeToWishlist(selected);
    }
    emit(state.copyWith(selectedItems: {}));
  }

  void _onUpdateWishlistItems(
      UpdateWishlistItems event, Emitter<WishlistState> emit) async {
    emit(state.copyWith(wishlistItems: event.wishlistItems));
  }

  bool isItemSelected(ProductItem item) {
    return state.selectedItems.contains(item.id);
  }

  // @override
  // Future<void> close() {
  //   _wishlistItemsSubscription.cancel();
  //   return super.close();
  // }
}
