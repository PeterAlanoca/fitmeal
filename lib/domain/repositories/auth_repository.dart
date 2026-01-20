import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';

abstract class IAuthRepository {
  Future<Either<Failure, User>> signIn({
    required String username,
    required String password,
    required String pushToken,
  });

  Future<Either<Failure, bool>> signUp({
    required String username,
    required String password,
    required String name,
    required String lastName,
    required String email,
    required String birthdate,
  });
}
