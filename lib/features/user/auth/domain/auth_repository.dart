import 'package:hairguide_barberpedia/features/user/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<void> refreshToken();
  Future<bool> isLoggedIn();
  Future<String?> getRole();
  Future<void> logout();
}
