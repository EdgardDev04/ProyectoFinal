import 'package:flutter_sweet_shop_app_ui/data/address_model.dart';
import 'package:flutter_sweet_shop_app_ui/data/db.dart';

class AddressRepository {
  final db = AppDatabase.instance;

  Future<List<AddressModel>> getAddresses() async {
    return await AppDatabase.getAddresses();
  }

  Future<void> addAddress(AddressModel address) async {
    await AppDatabase.insertAddress(address);
  }

  Future<void> selectAddress(int id) async {
    await AppDatabase.selectAddress(id);
  }

  Future<void> deleteAddress(int id) async {
    await AppDatabase.deleteAddress(id);
  }
}
