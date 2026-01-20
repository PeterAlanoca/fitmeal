import 'package:flutter/material.dart';
import '../../domain/usecases/sign_in_usecase.dart';

class LoginViewModel extends ChangeNotifier {
  final SignInUseCase signInUseCase;

  LoginViewModel(this.signInUseCase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await signInUseCase(
      username: username,
      password: password,
      pushToken: '3e3232323asasasasasas', // Default for now
    );

    return result.fold(
      (failure) {
        _isLoading = false;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) {
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
}
