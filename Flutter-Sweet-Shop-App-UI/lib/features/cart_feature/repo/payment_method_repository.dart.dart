import 'package:flutter_sweet_shop_app_ui/data/db.dart';

class PaymentMethodRepository {
  Future<void> saveMethod(String method) async {
    await AppDatabase.savePaymentMethod(method);
  }

  Future<String?> loadMethod() async {
    return await AppDatabase.getPaymentMethod();
  }
}
