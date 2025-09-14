import 'package:ecommerce_task/features/auth/data/models/user_model.dart';
import 'package:hive/hive.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box box;
  static const String userKey = 'cached_user';

  AuthLocalDataSourceImpl(this.box);

  @override
  Future<UserModel?> getCachedUser() async {
    return box.get(userKey);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await box.put(userKey, user);
  }

  @override
  Future<void> clearCache() async {
    await box.delete(userKey);
  }
}
