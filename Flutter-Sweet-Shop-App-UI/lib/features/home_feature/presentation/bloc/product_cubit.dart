import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/presentation/bloc/product_state.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/repo/product_repository.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repo;

  ProductCubit(this.repo) : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      final products = await repo.getAllProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError("Error cargando productos"));
    }
  }

  Future<void> search(String query) async {
    emit(ProductLoading());
    try {
      final products = await repo.searchProducts(query);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError("Error buscando productos"));
    }
  }

  Future<void> applyFilter({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? sort,
  }) async {
    emit(ProductLoading());
    try {
      final products = await repo.filterProducts(
        search: search,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sort: sort,
      );
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError("Error aplicando filtros"));
    }
  }
}
