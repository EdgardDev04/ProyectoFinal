import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sweet_shop_app_ui/features/cart_feature/repo/payment_method_repository.dart.dart';
import 'payment_method_state.dart';

class PaymentMethodCubit extends Cubit<PaymentMethodState> {
  final PaymentMethodRepository repository;

  PaymentMethodCubit(this.repository) : super(PaymentMethodState());

  Future<void> loadPaymentMethod() async {
    emit(state.copyWith(loading: true));

    final method = await repository.loadMethod();

    emit(state.copyWith(
      selectedMethod: method,
      loading: false,
    ));
  }

  Future<void> savePaymentMethod(String method) async {
    emit(state.copyWith(loading: true));

    await repository.saveMethod(method);

    emit(state.copyWith(
      selectedMethod: method,
      loading: false,
    ));
  }
}
