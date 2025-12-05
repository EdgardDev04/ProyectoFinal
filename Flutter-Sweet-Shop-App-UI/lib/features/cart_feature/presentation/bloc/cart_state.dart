part of 'cart_cubit.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> items;
  final int totalItems;
  final int totalAmount;

  CartLoaded({
    required this.items,
    required this.totalItems,
    required this.totalAmount,
  });

}

class CartError extends CartState {
  final String message;
  CartError({required this.message});
}



