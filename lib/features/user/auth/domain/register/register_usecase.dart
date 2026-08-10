import 'package:hairguide_barberpedia/features/user/auth/domain/entities/register/register_entity.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/register/register_repository.dart';


class RegisterUseCase {
  final RegisterRepository repository;
  RegisterUseCase(this.repository);

  Future<RegisterEntity> call({
    required String email,
    required String phone,
    required String password,
    required String name,
    required String dob,
  }) async {
    return await repository.registerUser(
      email: email,
      phone: phone,
      password: password,
      name: name,
      dob: dob,
    );
  }
}
