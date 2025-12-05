import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_scaffold.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/general_app_bar.dart';
import 'package:flutter_sweet_shop_app_ui/data/special_offer_local_data_source.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/presentation/bloc/special_offer_bloc.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/repo/special_offer_repository.dart';
import '../../../../core/theme/dimens.dart';
import '../../../../data/sample_data.dart';


class SpecialOffers extends StatelessWidget {
  const SpecialOffers({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SpecialOfferBloc(
        SpecialOfferRepository(
          SpecialOfferLocalDataSource(),
        ),
      )..add(LoadSpecialOffersEvent(banners)),
      child: AppScaffold(
        appBar: GeneralAppBar(title: 'Ofertas Especiales'),
        body: BlocBuilder<SpecialOfferBloc, SpecialOfferState>(
          builder: (context, state) {
            if (state is SpecialOfferLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            final offers = (state as SpecialOfferLoadedState).offers;

            return ListView.separated(
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];

                return InkWell(
                  onTap: () {
                    context
                        .read<SpecialOfferBloc>()
                        .add(ToggleFavoriteEvent(offer));
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Dimens.largePadding),
                        child: Image.asset(offer.bannerPath),
                      ),
                      Positioned(
                        right: 16,
                        top: 16,
                        child: Icon(
                          offer.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, __) =>
                  SizedBox(height: Dimens.largePadding),
            );
          },
        ),
      ),
    );
  }
}
