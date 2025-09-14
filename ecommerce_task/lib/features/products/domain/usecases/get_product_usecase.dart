import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await repository.getProducts();
  }
}

class GetProductDetailUseCase implements UseCase<Product, ProductDetailParams> {
  final ProductRepository repository;

  GetProductDetailUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(ProductDetailParams params) async {
    return await repository.getProductById(params.id);
  }
}

class ProductDetailParams {
  final int id;

  ProductDetailParams({required this.id});
}
