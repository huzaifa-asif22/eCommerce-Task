import '../models/user_model.dart';
import '../../../../core/network/api_client.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String name);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    // Mock successful login
    return const UserModel(
      id: 1,
      email: 'user@example.com',
      name: 'John Doe',
      profileImage: null,
    );
  }

  @override
  Future<UserModel> register(String email, String password, String name) async {
    // Simulate API call
    final userData = {'email': email, 'name': name, 'password': password};

    try {
      final response = await apiClient.register(userData);
      return UserModel(
        id: response.id,
        email: response.email,
        name: response.name,
        profileImage: response.profileImage,
      );
    } catch (e) {
      // If API call fails, return mock data for demo
      return UserModel(
        id: DateTime.now().millisecondsSinceEpoch,
        email: email,
        name: name,
        profileImage: null,
      );
    }
  }

  @override
  Future<void> logout() async {
    // Simulate logout delay
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
