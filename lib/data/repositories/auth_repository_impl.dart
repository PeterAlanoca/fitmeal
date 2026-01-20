import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepository implements IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;

  AuthRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> signIn({
    required String username,
    required String password,
    required String pushToken,
  }) async {
    try {
      final userModel = await remoteDataSource.signIn(username, password, pushToken);
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> signUp({
    required String username,
    required String password,
    required String name,
    required String lastName,
    required String email,
    required String birthdate,
  }) async {
    try {
      final response = await remoteDataSource.signUp(
        username: username,
        password: password,
        name: name,
        lastName: lastName,
        email: email,
        birthdate: birthdate,
      );
      if (response.success) {
        return const Right(true);
      } else {
        return Left(AuthFailure(response.message ?? 'Sign up failed'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
