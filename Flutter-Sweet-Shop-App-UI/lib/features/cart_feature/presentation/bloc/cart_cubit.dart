import 'package:bloc/bloc.dart';
import 'package:flutter_sweet_shop_app_ui/data/cart_item_model.dart';
import 'package:flutter_sweet_shop_app_ui/data/product_model.dart';
import 'package:flutter_sweet_shop_app_ui/features/cart_feature/repo/cart_repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository repository;

  CartCubit(this.repository) : super(CartInitial()) {
    loadCart();
  }

  List<CartItemModel> _items = [];

  Future<void> loadCart() async {
    try {
      emit(CartInitial());
      _items = await repository.getCartItems();
      emit(_buildLoadedState());
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> addItem(ProductModel product) async {
    try {
      await repository.addToCart(product);
      await loadCart();
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    try {
      if (quantity <= 0) {
        await repository.removeItem(productId);
      } else {
        await repository.updateQuantity(productId, quantity);
      }
      await loadCart();
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> incrementQuantity(int productId) async {
    try {
      final item = _items.firstWhere((i) => i.product.id == productId);
      await repository.updateQuantity(productId, item.quantity + 1);
      await loadCart();
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> decrementQuantity(int productId) async {
    try {
      final item = _items.firstWhere((i) => i.product.id == productId);
      if (item.quantity <= 1) {
        await repository.removeItem(productId);
      } else {
        await repository.updateQuantity(productId, item.quantity - 1);
      }
      await loadCart();
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> removeItem(int productId) async {
    try {
      await repository.removeItem(productId);
      await loadCart();
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> clearCart() async {
    try {
      await repository.clearCart();
      await loadCart();
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  CartLoaded _buildLoadedState() {
    final totalAmount = _items.fold(0.0, (sum, i) => sum + i.totalPrice);
    final totalItems = _items.fold(0, (sum, i) => sum + i.quantity);

    return CartLoaded(
      items: List.from(_items),
      totalAmount: totalAmount.toInt(),
      totalItems: totalItems,
    );
  }

  bool isProductInCart(int productId) {
    return _items.any((item) => item.product.id == productId);
  }
}
