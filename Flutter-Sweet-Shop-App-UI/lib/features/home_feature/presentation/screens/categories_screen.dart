import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/dimens.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/rate_widget.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/presentation/bloc/category_cubit.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/presentation/bloc/product_cubit.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/presentation/bloc/product_state.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_title_widget.dart';
import '../../../../core/widgets/general_app_bar.dart';
import '../../../cart_feature/presentation/bloc/cart_cubit.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: GeneralAppBar(title: 'Categorias'),
      padding: EdgeInsets.zero,
      body: BlocBuilder<CategoryCubit, List<String>>(
        builder: (context, categories) {
          if (categories.isEmpty) {
            return Center(child: Text("No hay categorías"));
          }

          return ListView.separated(
            itemCount: categories.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final category = categories[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTitleWidget(
                    thumbnailPath: "assets/images/default_category.png",
                    title: category,
                    onPressed: () {},
                  ),
                  SizedBox(
                    height: 264,
                    child: BlocBuilder<ProductCubit, ProductState>(
                      builder: (context, state) {
                        if (state is ProductLoading) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (state is ProductLoaded) {
                          final products = state.products
                              .where((p) => p.category == category)
                              .toList();

                          if (products.isEmpty) {
                            return Center(child: Text("Sin productos"));
                          }

                          return ListView.builder(
                            itemCount: products.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              final product = products[i];

                              return Container(
                                width: 138,
                                height: 243,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(Dimens.largePadding),
                                  boxShadow: [
                                    BoxShadow(
                                      color: context.theme.appColors.black.withValues(alpha: 0.1),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.only(
                                  left: Dimens.largePadding,
                                  top: Dimens.smallPadding,
                                  bottom: Dimens.smallPadding,
                                ),
                                child: Column(
                                  spacing: Dimens.padding,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 110,
                                      width: 180,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(Dimens.corners),
                                        child: Image.asset(
                                          product.imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 32,
                                      child: Center(
                                        child: Text(
                                          product.name,
                                          style: context.theme.appTypography.labelMedium
                                              .copyWith(fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        RateWidget(rate: '7.10'),
                                        Text('1K+ Reseñas', style: TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                    Text(
                                      '\$ ${product.price}',
                                      style: context.theme.appTypography.labelLarge
                                          .copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      height: 32,
                                      child: AppButton(
                                        title: 'Agregar al Carrito',
                                        onPressed: () {
                                          context.read<CartCubit>().addItem(product);
                                        },
                                        margin: EdgeInsets.zero,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }

                        return SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: Dimens.largePadding),
          );
        },
      ),
    );
  }
}

