import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/products/data/models/product_model.dart';
import '../../features/auth/data/models/user_model.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'https://fakestoreapi.com')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  // Products endpoints
  @GET('/products')
  Future<List<ProductModel>> getProducts();

  @GET('/products/{id}')
  Future<ProductModel> getProductById(@Path('id') int id);

  @GET('/products/categories')
  Future<List<String>> getCategories();

  // Auth endpoints (using JSONPlaceholder for demo)
  @POST('/users')
  Future<UserModel> register(@Body() Map<String, dynamic> userData);
}
