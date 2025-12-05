import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sweet_shop_app_ui/data/address_model.dart';
import 'package:flutter_sweet_shop_app_ui/features/cart_feature/repo/address_repository.dart';

class AddressState {}

class AddressInitial extends AddressState {}

class AddressLoaded extends AddressState {
  final List<AddressModel> addresses;
  AddressLoaded(this.addresses);
}

class AddressCubit extends Cubit<AddressState> {
  final AddressRepository repo;
  AddressCubit(this.repo) : super(AddressInitial());

  Future<void> load() async {
    final data = await repo.getAddresses();
    emit(AddressLoaded(data));
  }

  Future<void> add(String title, String fullAddress) async {
    await repo.addAddress(AddressModel(
      title: title,
      fullAddress: fullAddress,
      isSelected: false,
    ));
    load();
  }

  Future<void> select(int id) async {
    await repo.selectAddress(id);
    load();
  }

  Future<void> delete(int id) async {
    await repo.deleteAddress(id);
    load();
  }
}
