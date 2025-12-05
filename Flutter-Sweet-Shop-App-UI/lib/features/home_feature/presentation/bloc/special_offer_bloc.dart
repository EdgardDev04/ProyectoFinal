import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sweet_shop_app_ui/data/special_offer_model.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/repo/special_offer_repository.dart';

abstract class SpecialOfferEvent {}

class LoadSpecialOffersEvent extends SpecialOfferEvent {
  final List<String> banners;
  LoadSpecialOffersEvent(this.banners);
}

class ToggleFavoriteEvent extends SpecialOfferEvent {
  final SpecialOfferModel offer;
  ToggleFavoriteEvent(this.offer);
}


abstract class SpecialOfferState {}

class SpecialOfferLoadingState extends SpecialOfferState {}

class SpecialOfferLoadedState extends SpecialOfferState {
  final List<SpecialOfferModel> offers;
  SpecialOfferLoadedState(this.offers);
}


class SpecialOfferBloc extends Bloc<SpecialOfferEvent, SpecialOfferState> {
  final SpecialOfferRepository repo;
  late List<String> _banners;

  SpecialOfferBloc(this.repo) : super(SpecialOfferLoadingState()) {
    on<LoadSpecialOffersEvent>(_load);
    on<ToggleFavoriteEvent>(_toggle);
  }

  Future<void> _load(
    LoadSpecialOffersEvent event,
    Emitter<SpecialOfferState> emit,
  ) async {
    emit(SpecialOfferLoadingState());

    /// Guardamos los banners
    _banners = event.banners;

    final data = await repo.loadOffers(_banners);
    emit(SpecialOfferLoadedState(data));
  }

  Future<void> _toggle(
    ToggleFavoriteEvent event,
    Emitter<SpecialOfferState> emit,
  ) async {
    await repo.toggleFavorite(event.offer);

    /// Usamos la lista guardada
    final refreshed = await repo.loadOffers(_banners);

    emit(SpecialOfferLoadedState(refreshed));
  }
}
