import 'package:dio/dio.dart';
import '../models/auth_models.dart';

abstract class IAuthRemoteDataSource {
  Future<AuthResponseModel> signIn(String username, String password, String pushToken);
  Future<GenericResponseModel> signUp({
    required String username,
    required String password,
    required String name,
    required String lastName,
    required String email,
    required String birthdate,
  });
}

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  @override
  Future<AuthResponseModel> signIn(String username, String password, String pushToken) async {
    final response = await dio.post(
      'https://web.fitMeal.com/api/v1/sign_in',
      data: {
        'username': username,
        'password': password,
        'push_token': pushToken,
      },
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(response.data);
    } else {
      throw Exception('Failed to sign in');
    }
  }

  @override
  Future<GenericResponseModel> signUp({
    required String username,
    required String password,
    required String name,
    required String lastName,
    required String email,
    required String birthdate,
  }) async {
    final response = await dio.post(
      'https://web.fitMeal.com/api/v1/sign_up',
      data: {
        'username': username,
        'password': password,
        'name': name,
        'last_name': lastName,
        'email': email,
        'birthdate': birthdate,
      },
    );

    if (response.statusCode == 200) {
      return GenericResponseModel.fromJson(response.data);
    } else {
      throw Exception('Failed to sign up');
    }
  }
}
