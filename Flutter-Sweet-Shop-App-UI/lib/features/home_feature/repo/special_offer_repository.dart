
import 'package:flutter_sweet_shop_app_ui/data/special_offer_local_data_source.dart';
import 'package:flutter_sweet_shop_app_ui/data/special_offer_model.dart';

class SpecialOfferRepository {
  final SpecialOfferLocalDataSource local;

  SpecialOfferRepository(this.local);

  Future<List<SpecialOfferModel>> loadOffers(List<String> banners) async {
    final stored = await local.getAll();

    if (stored.isEmpty) {
      final initialData = banners
          .map((e) =>
              SpecialOfferModel(bannerPath: e, isFavorite: false))
          .toList();

      for (var item in initialData) {
        await local.saveOffer(item);
      }
      return initialData;
    }

    return stored;
  }

  Future<void> toggleFavorite(SpecialOfferModel offer) async {
    final updated = offer.copyWith(isFavorite: !offer.isFavorite);
    await local.saveOffer(updated);
  }
}
