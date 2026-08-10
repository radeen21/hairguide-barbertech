import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/get_role_usecase.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/login_usecase.dart';

import '../../domain/entities/user_entity.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final GetRoleUseCase getRoleUseCase;

  UserEntity? user;

  AuthProvider(this.loginUseCase, this.getRoleUseCase);

  Future<bool> login(String email, String password) async {
    try {
      user = await loginUseCase(email, password);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> getRole() => getRoleUseCase();
}
