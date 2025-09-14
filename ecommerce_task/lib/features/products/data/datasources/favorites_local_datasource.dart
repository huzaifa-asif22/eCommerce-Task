import 'package:hive/hive.dart';

abstract class FavoritesLocalDataSource {
  Future<Set<int>> getCachedFavorites();
  Future<void> cacheFavorites(Set<int> favorites);
  Future<void> clearFavorites();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final Box box;
  static const String favoritesKey = 'cached_favorites';

  FavoritesLocalDataSourceImpl(this.box);

  @override
  Future<Set<int>> getCachedFavorites() async {
    final favoritesList = box.get(favoritesKey, defaultValue: <int>[]);
    return Set<int>.from(favoritesList);
  }

  @override
  Future<void> cacheFavorites(Set<int> favorites) async {
    await box.put(favoritesKey, favorites.toList());
  }

  @override
  Future<void> clearFavorites() async {
    await box.delete(favoritesKey);
  }
}