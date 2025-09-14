import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductDetailUseCase implements UseCase<Product, ProductDetailParams> {
  final ProductRepository repository;

  GetProductDetailUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(ProductDetailParams params) async {
    return await repository.getProductById(params.id);
  }
}

class ProductDetailParams extends Equatable {
  final int id;

  const ProductDetailParams({required this.id});

  @override
  List<Object> get props => [id];
}