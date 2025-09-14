import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/products/data/datasources/product_remote_datasource.dart';
import '../../features/products/data/datasources/favorites_local_datasource.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/get_products_usecase.dart';
import '../../features/products/domain/usecases/get_product_detail_usecase.dart';
import '../network/api_client.dart';
import '../platform/device_info_channel.dart';

// Network
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.baseUrl = 'https://fakestoreapi.com';
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.read(dioProvider);
  return ApiClient(dio);
});

// Local Storage - These will be overridden in main.dart
late final SharedPreferences _sharedPreferences;
late final Box _authBox;
late final Box _favoritesBox;

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => _sharedPreferences);

final authBoxProvider = Provider<Box>((ref) => _authBox);

final favoritesBoxProvider = Provider<Box>((ref) => _favoritesBox);

// Data Sources
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AuthRemoteDataSourceImpl(apiClient);
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final authBox = ref.read(authBoxProvider);
  return AuthLocalDataSourceImpl(authBox);
});

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((
  ref,
) {
  final apiClient = ref.read(apiClientProvider);
  return ProductRemoteDataSourceImpl(apiClient);
});

final favoritesLocalDataSourceProvider = Provider<FavoritesLocalDataSource>((ref) {
  final favoritesBox = ref.read(favoritesBoxProvider);
  return FavoritesLocalDataSourceImpl(favoritesBox);
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.read(authRemoteDataSourceProvider);
  final localDataSource = ref.read(authLocalDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource, localDataSource);
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remoteDataSource = ref.read(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(remoteDataSource);
});

// Use Cases
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LoginUseCase(repository);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return RegisterUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LogoutUseCase(repository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  final repository = ref.read(productRepositoryProvider);
  return GetProductsUseCase(repository);
});

final getProductDetailUseCaseProvider = Provider<GetProductDetailUseCase>((
  ref,
) {
  final repository = ref.read(productRepositoryProvider);
  return GetProductDetailUseCase(repository);
});

// Platform Channels
final deviceInfoChannelProvider = Provider<DeviceInfoChannel>((ref) {
  return DeviceInfoChannel();
});

// Setup function
Future<void> setupDI() async {
  _sharedPreferences = await SharedPreferences.getInstance();
  _authBox = await Hive.openBox('auth');
  _favoritesBox = await Hive.openBox('favorites');
}
