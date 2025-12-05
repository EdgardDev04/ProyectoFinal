class PaymentMethodModel {
  final int id;
  final String method;

  PaymentMethodModel({
    this.id = 1,
    required this.method,
  });

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodModel(
      id: map['id'],
      method: map['method'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'method': method,
    };
  }
}
