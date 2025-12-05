import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/dimens.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';
import 'package:flutter_sweet_shop_app_ui/core/utils/app_navigator.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_divider.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_scaffold.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_svg_viewer.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/bordered_container.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/general_app_bar.dart';
import 'package:flutter_sweet_shop_app_ui/data/address_model.dart';
import 'package:flutter_sweet_shop_app_ui/features/cart_feature/presentation/bloc/address_cubit.dart';
import 'package:flutter_sweet_shop_app_ui/features/cart_feature/presentation/screens/change_address_screen.dart';
import 'package:flutter_sweet_shop_app_ui/features/cart_feature/presentation/screens/payment_methods_screen.dart';
import 'package:flutter_sweet_shop_app_ui/features/cart_feature/presentation/widgets/orders_list_for_checkout.dart';
import 'package:flutter_sweet_shop_app_ui/features/cart_feature/presentation/widgets/payment_details_item.dart';

import '../../../../core/gen/assets.gen.dart';
import '../../../../core/widgets/app_button.dart';

class ProceedToCheckoutScreen extends StatelessWidget {
  const ProceedToCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appTypography = context.theme.appTypography;
    final appColors = context.theme.appColors;

    return AppScaffold(
      appBar: GeneralAppBar(title: 'Procesar Pago'),
      body: SingleChildScrollView(
        child: Column(
          spacing: Dimens.largePadding,
          children: [
            SizedBox.shrink(),

            BorderedContainer(
              padding: EdgeInsets.symmetric(horizontal: Dimens.largePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimens.largePadding,
                    ),
                    child: Text(
                      'Detalles de Pagos',
                      style: appTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  AppDivider(),
                  PaymentDetailsItem(title: 'Producto', subtitle: '\$ 98.00'),
                  PaymentDetailsItem(title: 'Delivery', subtitle: '\$ 10.00'),
                  PaymentDetailsItem(title: 'Discount', subtitle: '\$ 10.00'),
                  Text(
                    ' - - - - - - - -' * 10,
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    style: TextStyle(color: appColors.gray2),
                  ),
                  PaymentDetailsItem(title: 'Total: ', subtitle: '\$ 98.00'),
                ],
              ),
            ),

            BorderedContainer(
              padding: EdgeInsets.symmetric(horizontal: Dimens.largePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Dimens.padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Destino',
                          style: appTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        BorderedContainer(
                          borderColor: appColors.primary,
                          borderRadius: Dimens.smallCorners,
                          child: InkWell(
                            onTap: () async {
                              await appPush(context, ChangeAddressScreen());
                              context.read<AddressCubit>().load();
                            },
                            borderRadius: BorderRadius.circular(
                              Dimens.smallCorners,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(Dimens.padding),
                              child: Text(
                                'Cambiar Dirección',
                                style: TextStyle(color: appColors.primary),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: Dimens.largePadding),
                  AppDivider(),
                  BlocBuilder<AddressCubit, AddressState>(
                  builder: (context, state) {
                    if (state is AddressLoaded) {
                      AddressModel? selected;

                      for (final a in state.addresses) {
                        if (a.isSelected) {
                          selected = a;
                          break;
                        }
                      }

                      if (selected == null) {
                        return ListTile(
                          leading: Icon(Icons.location_off, color: appColors.error),
                          title: Text(
                            "No hay dirección seleccionada",
                            style: appTypography.titleSmall.copyWith(
                              color: appColors.gray4,
                            ),
                          ),
                        );
                      }
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: Dimens.smallPadding,
                          ),
                          leading: AppSvgViewer(
                            Assets.icons.location,
                            color: appColors.primary,
                          ),
                          title: Text(
                            selected.fullAddress,
                            style: appTypography.titleSmall.copyWith(
                              color: appColors.gray4,
                            ),
                          ),
                        );
                      }

                      return ListTile(
                        title: Text(
                          "Cargando dirección...",
                          style: appTypography.titleSmall,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ordenes',
                    style: appTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: Dimens.largePadding),
                  AppDivider(),
                  OrdersListForCheckout(),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: Dimens.largePadding,
          right: Dimens.largePadding,
          bottom: Dimens.padding,
        ),
        child: AppButton(
          onPressed: () {
            appPush(context, PaymentMethodsScreen());
          },
          title: 'Continuar Pago',
          textStyle: appTypography.bodyLarge,
          borderRadius: Dimens.corners,
          margin: EdgeInsets.symmetric(vertical: Dimens.largePadding),
        ),
      ),
    );
  }
}
