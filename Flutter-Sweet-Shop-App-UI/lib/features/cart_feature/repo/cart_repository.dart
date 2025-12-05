import 'package:flutter_sweet_shop_app_ui/data/db.dart';
import 'package:flutter_sweet_shop_app_ui/data/cart_item_model.dart';
import 'package:flutter_sweet_shop_app_ui/data/product_model.dart';

class CartRepository {

  Future<List<CartItemModel>> getCartItems() async {
    return await AppDatabase.getCartItems();
  }

  Future<void> addToCart(ProductModel product) async {
    final exists = await AppDatabase.getCartItem(product.id);

    if (exists == null) {
      await AppDatabase.insertCartItem(
        CartItemModel(product: product, quantity: 1),
      );
    } else {
      await AppDatabase.updateCartItem(
        CartItemModel(
          product: product,
          quantity: exists.quantity + 1,
        ),
      );
    }
  }

  Future<void> updateQuantity(int productId, int newQty) async {
    final item = await AppDatabase.getCartItem(productId);
    if (item != null) {
      await AppDatabase.updateCartItem(
        CartItemModel(product: item.product, quantity: newQty),
      );
    }
  }

  Future<void> removeItem(int productId) async {
    await AppDatabase.deleteCartItem(productId);
  }

  Future<void> clearCart() async {
    await AppDatabase.clearCart();
  }
}
