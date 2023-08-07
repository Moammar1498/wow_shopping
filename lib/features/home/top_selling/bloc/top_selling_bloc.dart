import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/models/product_item.dart';

part 'top_selling_event.dart';
part 'top_selling_state.dart';

class TopSellingBloc extends Bloc<TopSellingEvent, TopSellingState> {
  TopSellingBloc({
    required ProductsRepo productsRepo,
  })  : _productsRepo = productsRepo,
        super(TopSellingInitial()) {
    on<TopSellingFetchRequested>(_onTopSellingFetchRequested);
  }
  final ProductsRepo _productsRepo;

  Future<void> _onTopSellingFetchRequested(
    TopSellingFetchRequested event,
    Emitter<TopSellingState> emit,
  ) async {
    emit(TopSellingLoading());

    try {
      final topSellingProducts = await _productsRepo.fetchTopSelling();
      emit(TopSellingLoaded(topSellingProducts));
    } catch (_) {
      emit(TopSellingFailure());
    }
  }
}
