import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_product_detail_usecase.dart';

final productListProvider = FutureProvider<List<Product>>((ref) async {
  final getProductsUseCase = ref.read(getProductsUseCaseProvider);
  final result = await getProductsUseCase(NoParams());

  return result.fold(
    (failure) => throw Exception(failure.message),
    (products) => products,
  );
});

final productDetailProvider = FutureProvider.family<Product, int>((
  ref,
  productId,
) async {
  final getProductDetailUseCase = ref.read(getProductDetailUseCaseProvider);
  final result = await getProductDetailUseCase(
    ProductDetailParams(id: productId),
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (product) => product,
  );
});

class FavoritesState {
  final Set<int> favorites;
  final bool isLoading;

  const FavoritesState({this.favorites = const {}, this.isLoading = false});

  FavoritesState copyWith({Set<int>? favorites, bool? isLoading}) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final Ref ref;

  FavoritesNotifier(this.ref) : super(const FavoritesState()) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      state = state.copyWith(isLoading: true);
      final favoritesDataSource = ref.read(favoritesLocalDataSourceProvider);
      final favorites = await favoritesDataSource.getCachedFavorites();
      state = state.copyWith(favorites: favorites, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> toggleFavorite(int productId) async {
    final newFavorites = Set<int>.from(state.favorites);

    if (newFavorites.contains(productId)) {
      newFavorites.remove(productId);
    } else {
      newFavorites.add(productId);
    }

    // Update local storage
    final favoritesDataSource = ref.read(favoritesLocalDataSourceProvider);
    await favoritesDataSource.cacheFavorites(newFavorites);

    // Update state
    state = state.copyWith(favorites: newFavorites);
  }

  bool isFavorite(int productId) {
    return state.favorites.contains(productId);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
      return FavoritesNotifier(ref);
    });
