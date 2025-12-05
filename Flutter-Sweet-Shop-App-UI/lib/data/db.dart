import 'dart:async';
import 'package:flutter_sweet_shop_app_ui/data/address_model.dart';
import 'package:flutter_sweet_shop_app_ui/data/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'product_model.dart';
import 'cart_item_model.dart';
import 'banner_model.dart';
import 'category_model.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> get instance async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sweetshop.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
static Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sweetshop.db');
    await deleteDatabase(path);
  }


  static Future _onCreate(Database db, int version) async {
    await db.execute('PRAGMA foreign_keys = ON');

    // ------------------ USERS ------------------
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        salt TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // ------------------ PRODUCTS ------------------
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        image TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        categoryId INTEGER,
        FOREIGN KEY(categoryId) REFERENCES categories(id) ON DELETE SET NULL
      )
    ''');

    // ------------------ CATEGORIES ------------------
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        image TEXT NOT NULL
      )
    ''');

    // ------------------ CART ------------------
    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY(productId) REFERENCES products(id) ON DELETE CASCADE
      )
    ''');

    // ------------------ BANNERS ------------------
    await db.execute('''
      CREATE TABLE banners (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image TEXT NOT NULL
      )
    ''');

    // ------------------ ADDRESSES ------------------
    await db.execute('''
      CREATE TABLE addresses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        fullAddress TEXT NOT NULL,
        isSelected INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // ------------------ SPECIAL OFFERS ------------------
    await db.execute('''
      CREATE TABLE special_offers (
        bannerPath TEXT PRIMARY KEY,
        isFavorite INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // ------------------ PAYMENT METHOD ------------------
    await db.execute('''
      CREATE TABLE payment_method (
        id INTEGER PRIMARY KEY,
        method TEXT NOT NULL
      )
    ''');

    // ------------------ FILTERS ------------------
    await db.execute('''
      CREATE TABLE filters (
        id INTEGER PRIMARY KEY,
        sort TEXT NOT NULL DEFAULT 'Mejor Puntuación',
        category TEXT NOT NULL DEFAULT 'Todos'
      )
    ''');

    // Insert default filter
    await db.insert('filters', {
      'id': 1,
      'sort': 'Mejor Puntuación',
      'category': 'Todos',
    });
  }

  static Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('PRAGMA foreign_keys = ON');

    if (oldVersion < 4) {
      // Version 4 agrega special_offers y filters si no existen
      await db.execute('''
        CREATE TABLE IF NOT EXISTS special_offers (
          bannerPath TEXT PRIMARY KEY,
          isFavorite INTEGER NOT NULL DEFAULT 0
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS filters (
          id INTEGER PRIMARY KEY,
          sort TEXT NOT NULL DEFAULT 'Mejor Puntuación',
          category TEXT NOT NULL DEFAULT 'Todos'
        )
      ''');

      await db.insert('filters', {
        'id': 1,
        'sort': 'Mejor Puntuación',
        'category': 'Todos',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  // ------------------ USERS ------------------
  static Future<int> insertUser(User user) async {
    final db = await instance;
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<User?> getUserByEmail(String email) async {
    final db = await instance;
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  static Future<User?> getUser(int id) async {
    final db = await instance;
    final res = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  // ------------------ PRODUCTS ------------------
  static Future<int> insertProduct(ProductModel product) async {
    final db = await instance;
    return await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<ProductModel?> getProduct(int id) async {
    final db = await instance;
    final res = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (res.isEmpty) return null;
    return ProductModel.fromMap(res.first);
  }

  static Future<List<ProductModel>> getAllProducts() async {
    final db = await instance;
    final res = await db.query('products');
    return res.map((e) => ProductModel.fromMap(e)).toList();
  }

  // ------------------ CART ------------------
  static Future<void> insertCartItem(CartItemModel item) async {
    final db = await instance;
    await insertProduct(item.product);
    await db.insert('cart', {
      'productId': item.product.id,
      'quantity': item.quantity,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateCartItem(CartItemModel item) async {
    final db = await instance;
    await db.update(
      'cart',
      {'quantity': item.quantity},
      where: 'productId = ?',
      whereArgs: [item.product.id],
    );
  }

  static Future<void> deleteCartItem(int productId) async {
    final db = await instance;
    await db.delete('cart', where: 'productId = ?', whereArgs: [productId]);
  }

  static Future<void> clearCart() async {
    final db = await instance;
    await db.delete('cart');
  }

  static Future<List<ProductModel>> getProducts({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? sort,
  }) async {
    final db = await instance;

    String where = "";
    List<dynamic> args = [];

    if (search != null && search.isNotEmpty) {
      where += "name LIKE ?";
      args.add("%$search%");
    }

    if (category != null && category.isNotEmpty) {
      if (where.isNotEmpty) where += " AND ";
      where += "category = ?";
      args.add(category);
    }

    if (minPrice != null) {
      if (where.isNotEmpty) where += " AND ";
      where += "price >= ?";
      args.add(minPrice);
    }

    if (maxPrice != null) {
      if (where.isNotEmpty) where += " AND ";
      where += " AND price <= ?";
      args.add(maxPrice);
    }

    String orderBy = "";
    if (sort == "price_asc") orderBy = "price ASC";
    if (sort == "price_desc") orderBy = "price DESC";

    final result = await db.query(
      "products",
      where: where.isEmpty ? null : where,
      whereArgs: args,
      orderBy: orderBy.isEmpty ? null : orderBy,
    );

    return result.map((e) => ProductModel.fromMap(e)).toList();
  }

  static Future<CartItemModel?> getCartItem(int productId) async {
    final db = await instance;
    final res = await db.query(
      'cart',
      where: 'productId = ?',
      whereArgs: [productId],
      limit: 1,
    );

    if (res.isEmpty) return null;

    final product = await getProduct(productId);
    if (product == null) return null;

    return CartItemModel(
      product: product,
      quantity: res.first['quantity'] as int,
    );
  }

  static Future<List<CartItemModel>> getCartItems() async {
    final db = await instance;
    final rows = await db.query('cart');
    List<CartItemModel> items = [];

    for (var row in rows) {
      final product = await getProduct(row['productId'] as int);
      if (product != null) {
        items.add(
          CartItemModel(product: product, quantity: row['quantity'] as int),
        );
      }
    }
    return items;
  }

  // ------------------ BANNERS ------------------
  static Future<void> insertBanners(List<String> list) async {
    final db = await instance;
    for (var image in list) {
      await db.insert('banners', {
        'image': image,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<List<BannerModel>> getBanners() async {
    final db = await instance;
    final res = await db.query('banners');
    return res.map((e) => BannerModel.fromMap(e)).toList();
  }

  // ------------------ CATEGORIES ------------------
  static Future<void> insertCategories(List<CategoryModel> list) async {
    final db = await instance;
    for (var c in list) {
      await db.insert(
        'categories',
        c.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<List<CategoryModel>> getCategories() async {
    final db = await instance;
    final res = await db.query('categories');
    return res.map((e) => CategoryModel.fromMap(e)).toList();
  }

  // ------------------ ADDRESSES ------------------
  static Future<int> insertAddress(AddressModel address) async {
    final db = await instance;
    await db.update('addresses', {'isSelected': 0});
    return await db.insert('addresses', address.toMap());
  }

  static Future<List<AddressModel>> getAddresses() async {
    final db = await instance;
    final res = await db.query('addresses');
    return res.map((e) => AddressModel.fromMap(e)).toList();
  }

  static Future<void> selectAddress(int id) async {
    final db = await instance;
    await db.update('addresses', {'isSelected': 0});
    await db.update(
      'addresses',
      {'isSelected': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteAddress(int id) async {
    final db = await instance;
    await db.delete('addresses', where: 'id = ?', whereArgs: [id]);
  }

  // ------------------ PAYMENT METHOD ------------------
  static Future<void> savePaymentMethod(String method) async {
    final db = await instance;
    await db.insert('payment_method', {
      'id': 1,
      'method': method,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<String?> getPaymentMethod() async {
    final db = await instance;
    final res = await db.query(
      'payment_method',
      where: 'id = ?',
      whereArgs: [1],
    );
    if (res.isEmpty) return null;
    return res.first['method'] as String;
  }

  // ------------------ SPECIAL OFFERS ------------------
  static Future<void> insertSpecialOffer(
    String bannerPath,
    int isFavorite,
  ) async {
    final db = await instance;
    await db.insert('special_offers', {
      'bannerPath': bannerPath,
      'isFavorite': isFavorite,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getSpecialOffers() async {
    final db = await instance;
    return await db.query('special_offers');
  }

  // ------------------ FILTERS ------------------
  static Future<void> saveFilters(String sort, String category) async {
    final db = await instance;
    await db.update('filters', {
      'sort': sort,
      'category': category,
    }, where: 'id = 1');
  }

  static Future<Map<String, String>> loadFilters() async {
    final db = await instance;
    final result = await db.query('filters', where: 'id = 1');
    if (result.isNotEmpty) {
      return {
        'sort': result.first['sort'] as String,
        'category': result.first['category'] as String,
      };
    }
    return {'sort': 'Mejor Puntuación', 'category': 'Todos'};
  }
}
