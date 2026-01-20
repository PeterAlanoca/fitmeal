import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final IAuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, bool>> call({
    required String username,
    required String password,
    required String name,
    required String lastName,
    required String email,
    required String birthdate,
  }) async {
    return await repository.signUp(
      username: username,
      password: password,
      name: name,
      lastName: lastName,
      email: email,
      birthdate: birthdate,
    );
  }
}
