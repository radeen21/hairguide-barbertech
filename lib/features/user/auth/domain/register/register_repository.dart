import 'package:hairguide_barberpedia/features/user/auth/domain/entities/register/register_entity.dart';

abstract class RegisterRepository {
  Future<RegisterEntity> registerUser({
    required String email,
    required String phone,
    required String password,
    required String name,
    required String dob,
  });
}
