import 'package:flutter_sweet_shop_app_ui/data/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'name': product.name,
      'price': product.price,
      'weight': product.weight,
      'rate': product.rate,
      'imageUrl': product.imageUrl,
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      product: ProductModel(
        id: map['productId'],
        name: map['name'],
        price: map['price'],
        weight: map['weight'],
        rate: map['rate'],
        imageUrl: map['imageUrl'],
        category: map['category'],
      ),
      quantity: map['quantity'],
    );
  }
}
