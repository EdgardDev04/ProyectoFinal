import 'package:flutter_sweet_shop_app_ui/data/db.dart';
import 'package:flutter_sweet_shop_app_ui/data/product_model.dart';

class ProductRepository {
  Future<List<ProductModel>> getAllProducts() async {
    return await AppDatabase.getAllProducts();
  }

  Future<ProductModel?> getProduct(int id) async {
    return await AppDatabase.getProduct(id);
  }

  Future<void> insertProduct(ProductModel product) async {
    await AppDatabase.insertProduct(product);
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final db = await AppDatabase.instance;
    final res = await db.query(
      'products',
      where: 'category = ?',
      whereArgs: [category],
    );
    return res.map((e) => ProductModel.fromMap(e)).toList();
  }

  Future<List<ProductModel>> searchProducts(String search) async {
    return await AppDatabase.getProducts(
      search: search,
    );
  }

  Future<List<ProductModel>> filterProducts({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? sort,
  }) async {
    return await AppDatabase.getProducts(
      search: search,
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sort: sort,
    );
  }
}


