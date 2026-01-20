import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final IAuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String username,
    required String password,
    required String pushToken,
  }) async {
    return await repository.signIn(
      username: username,
      password: password,
      pushToken: pushToken,
    );
  }
}
