class PaymentMethodState {
  final String? selectedMethod;
  final bool loading;

  PaymentMethodState({
    this.selectedMethod,
    this.loading = false,
  });

  PaymentMethodState copyWith({
    String? selectedMethod,
    bool? loading,
  }) {
    return PaymentMethodState(
      selectedMethod: selectedMethod ?? this.selectedMethod,
      loading: loading ?? this.loading,
    );
  }
}
