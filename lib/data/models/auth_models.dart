import '../../domain/entities/user.dart';

class AuthResponseModel extends User {
  AuthResponseModel({
    required super.name,
    required super.lastName,
    required super.email,
    required super.birthdate,
    required super.accessToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return AuthResponseModel(
      name: data['name'],
      lastName: data['last_name'],
      email: data['email'],
      birthdate: data['birthdate'],
      accessToken: data['access_token'],
    );
  }
}

class GenericResponseModel {
  final String code;
  final String? message;
  final bool success;

  GenericResponseModel({
    required this.code,
    this.message,
    required this.success,
  });

  factory GenericResponseModel.fromJson(Map<String, dynamic> json) {
    return GenericResponseModel(
      code: json['code'],
      message: json['message'],
      success: json['success'],
    );
  }
}
