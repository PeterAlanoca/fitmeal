import 'package:flutter/material.dart';
import '../../domain/usecases/sign_up_usecase.dart';

class RegisterViewModel extends ChangeNotifier {
  final SignUpUseCase signUpUseCase;

  RegisterViewModel(this.signUpUseCase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> register({
    required String username,
    required String password,
    required String name,
    required String lastName,
    required String email,
    required String birthdate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await signUpUseCase(
      username: username,
      password: password,
      name: name,
      lastName: lastName,
      email: email,
      birthdate: birthdate,
    );

    return result.fold(
      (failure) {
        _isLoading = false;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (success) {
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
}
