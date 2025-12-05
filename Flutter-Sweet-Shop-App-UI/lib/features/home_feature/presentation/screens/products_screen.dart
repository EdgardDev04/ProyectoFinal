import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';
import 'package:flutter_sweet_shop_app_ui/core/utils/app_navigator.dart';
import 'package:flutter_sweet_shop_app_ui/core/utils/sized_context.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_search_bar.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_svg_viewer.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/rate_widget.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/presentation/screens/sort_and_filter_screen.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/repo/product_repository.dart';

import '../../../../core/gen/assets.gen.dart';
import '../../../../core/theme/dimens.dart';
import '../../../../core/widgets/app_icon_buttons.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/general_app_bar.dart';
import '../../../../core/widgets/shaded_container.dart';
import '../../../../data/product_model.dart';
import '../bloc/product_cubit.dart';
import '../bloc/product_state.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;

    return BlocProvider(
      create: (_) => ProductCubit(ProductRepository())..loadProducts(),
      child: AppScaffold(
        appBar: GeneralAppBar(
          title: 'Productos',
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.largePadding),
              child: AppSearchBar(
                onChanged: (value) {
                  context.read<ProductCubit>().search(value);
                },
              ),
            ),
          ),
          height: 128,
        ),
        body: Column(
          spacing: Dimens.largePadding,
          children: [
            SizedBox.shrink(),
            Row(
              spacing: Dimens.largePadding,
              children: [
                GestureDetector(
                  onTap: () async {
                    final filters = await appPush(context, SortAndFilterScreen());

                    if (filters != null) {
                      context.read<ProductCubit>().applyFilter(
                        search: filters["search"],
                        category: filters["category"],
                        minPrice: filters["minPrice"],
                        maxPrice: filters["maxPrice"],
                        sort: filters["sort"],
                      );
                    }
                  },
                  child: ShadedContainer(
                    padding: EdgeInsets.all(Dimens.largePadding),
                    borderRadius: 100,
                    child: Row(
                      children: [
                        AppSvgViewer(Assets.icons.filterSearch, width: 16),
                        Text('Filtrar'),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final filters = await appPush(context, SortAndFilterScreen());

                    if (filters != null) {
                      context.read<ProductCubit>().applyFilter(
                        search: filters["search"],
                        category: filters["category"],
                        minPrice: filters["minPrice"],
                        maxPrice: filters["maxPrice"],
                        sort: filters["sort"],
                      );
                    }
                  },
                  child: ShadedContainer(
                    padding: EdgeInsets.all(Dimens.largePadding),
                    borderRadius: 100,
                    child: Row(
                      children: [
                        AppSvgViewer(Assets.icons.sort, width: 16),
                        Text('Ordenar'),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is ProductError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is ProductLoaded) {
                    return _buildGrid(context, state.products);
                  }

                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<ProductModel> products) {
    final appColors = context.theme.appColors;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Dimens.largePadding,
        crossAxisSpacing: Dimens.largePadding,
        mainAxisExtent: 210,
      ),
      itemCount: products.length,
      itemBuilder: (final context, final index) {
        final p = products[index];

        return ShadedContainer(
          child: Column(
            spacing: Dimens.padding,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimens.padding),
                child: SizedBox(
                  height: 114,
                  width: context.widthPx,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimens.corners),
                    child: Image.asset(
                      p.imageUrl,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.padding),
                child: Column(
                  spacing: Dimens.largePadding,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            p.name,
                            style: context.theme.appTypography.titleSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        RateWidget(rate: p.rating?.toString() ?? "7.10"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${p.price.toStringAsFixed(2)}',
                          style: context.theme.appTypography.labelLarge
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: AppIconButton(
                            iconPath: Assets.icons.shoppingCart,
                            backgroundColor: appColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
