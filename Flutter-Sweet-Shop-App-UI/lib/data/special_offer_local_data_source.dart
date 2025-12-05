import 'package:flutter_sweet_shop_app_ui/core/data/db.dart';
import 'package:flutter_sweet_shop_app_ui/data/special_offer_model.dart';
import 'package:sqflite/sqflite.dart';

class SpecialOfferLocalDataSource {
  Future<Database> get db async => await AppDatabase.instance.database;

  Future<List<SpecialOfferModel>> getAll() async {
    final database = await db;
    final result = await database.query('special_offers');
    return result.map((e) => SpecialOfferModel.fromMap(e)).toList();
  }

  Future<void> saveOffer(SpecialOfferModel offer) async {
    final database = await db;

    await database.insert(
      'special_offers',
      offer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
