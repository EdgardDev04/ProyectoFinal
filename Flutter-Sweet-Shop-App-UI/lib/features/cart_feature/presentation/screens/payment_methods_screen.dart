import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/dimens.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';
import 'package:flutter_sweet_shop_app_ui/core/utils/check_theme_status.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_scaffold.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/general_app_bar.dart';

import '../../../../core/gen/assets.gen.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/payment_method_cubit.dart';
import '../../presentation/widgets/payment_item_widget.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String? selectedPayment;

  @override
  void initState() {
    super.initState();

    // Obtener el método guardado del Cubit
    final initialMethod = context.read<PaymentMethodCubit>().state.selectedMethod;

    setState(() {
      selectedPayment = initialMethod;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appTypography = context.theme.appTypography;

    return AppScaffold(
      appBar: const GeneralAppBar(title: 'Métodos de Pago'),
      body: SingleChildScrollView(
        child: Column(
          spacing: Dimens.largePadding,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CASH
            PaymentItemWidget(
              onTap: () => _select("Cash"),
              title: 'Cash',
              iconPath: Assets.icons.money3,
              isSelected: selectedPayment == "Cash",
            ),

            /// TARJETA
            Text(
              'Tarjeta de crédito',
              style: appTypography.bodyLarge,
            ),

            PaymentItemWidget(
              onTap: () => _select("CreditCard"),
              title: 'Agregar tarjeta',
              iconPath: Assets.icons.card,
              showRadio: false,
              isSelected: selectedPayment == "CreditCard",
            ),
          ],
        ),
      ),

      /// BOTÓN DE CONFIRMACIÓN
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: Dimens.largePadding,
          right: Dimens.largePadding,
          bottom: Dimens.padding,
        ),
        child: AppButton(
          onPressed: _savePaymentMethod,
          title: 'Confirmación de Pago',
          textStyle: appTypography.bodyLarge,
          borderRadius: Dimens.corners,
          margin: const EdgeInsets.symmetric(vertical: Dimens.largePadding),
        ),
      ),
    );
  }

  /// Seleccionar el método localmente
  void _select(String value) {
    setState(() => selectedPayment = value);
  }

  /// Guardar método en SQLite mediante Cubit
  Future<void> _savePaymentMethod() async {
    if (selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un método de pago')),
      );
      return;
    }

    try {
      await context
          .read<PaymentMethodCubit>()
          .savePaymentMethod(selectedPayment!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Método "$selectedPayment" guardado correctamente'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al guardar el método de pago'),
        ),
      );
    }
  }
}
