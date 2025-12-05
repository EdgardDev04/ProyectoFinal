import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/repo/product_repository.dart';

class CategoryCubit extends Cubit<List<String>> {
  final ProductRepository repo;

  CategoryCubit(this.repo) : super([]);

  Future<void> loadCategories() async {
    final products = await repo.getAllProducts();
    final categories = products.map((e) => e.category).toSet().toList();
    emit(categories);
  }
}
