import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(int id);
  Future<List<String>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ProductModel>> getProducts() async {
    return await apiClient.getProducts();
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    return await apiClient.getProductById(id);
  }

  @override
  Future<List<String>> getCategories() async {
    return await apiClient.getCategories();
  }
}
