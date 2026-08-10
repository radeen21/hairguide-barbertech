import 'package:hairguide_barberpedia/features/user/auth/data/register/register_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/entities/register/register_entity.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/register/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource remoteDataSource;

  RegisterRepositoryImpl(this.remoteDataSource);

  @override
  Future<RegisterEntity> registerUser({
    required String email,
    required String phone,
    required String password,
    required String name,
    required String dob,
  }) async {
    final response = await remoteDataSource.registerUser(
      email: email,
      phone: phone,
      password: password,
      name: name,
      dob: dob,
    );

    final data = response["data"];
    return RegisterEntity.fromJson(data);
  }
}
