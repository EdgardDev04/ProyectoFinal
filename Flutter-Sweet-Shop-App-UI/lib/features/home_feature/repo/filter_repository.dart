import 'package:flutter_sweet_shop_app_ui/data/db.dart';

class FilterRepository {
  Future<void> saveFilters(String sort, String category) async {
    await AppDatabase.saveFilters(sort, category);
  }

  Future<Map<String, String>> loadFilters() async {
    return await AppDatabase.loadFilters();
  }
}
