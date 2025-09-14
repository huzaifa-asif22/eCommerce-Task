import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_task/features/auth/data/models/user_model.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      await localDataSource.cacheUser(user);
      return Right(user);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Login failed'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      final user = await remoteDataSource.register(email, password, name);
      await localDataSource.cacheUser(user);
      return Right(user);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Registration failed'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await localDataSource.clearCache();
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Logout failed'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure('Failed to get current user'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile(User user) async {
    try {
      final userModel = UserModel(
        id: user.id,
        email: user.email,
        name: user.name,
        profileImage: user.profileImage,
      );
      await localDataSource.cacheUser(userModel);
      return Right(user);
    } catch (e) {
      return Left(CacheFailure('Failed to update profile'));
    }
  }
}
