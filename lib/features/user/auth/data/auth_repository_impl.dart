import 'package:hairguide_barberpedia/features/user/auth/data/auth_local_data_source.dart';
import 'package:hairguide_barberpedia/features/user/auth/data/auth_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/auth/data/user_model.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/auth_repository.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepositoryImpl(this.remote, this.local);

 @override
  Future<UserEntity> login(String email, String password) async {
    final response = await remote.login(email, password);

    return UserModel.fromLoginResponse(response);
  }

  @override
  Future<void> refreshToken() async {
    final refresh = await local.getRefreshToken();
    if (refresh == null) return;

    final response = await remote.refreshToken(refresh);

    await local.saveRefresh(response);
  }

  @override
  Future<bool> isLoggedIn() => local.isLoggedIn();

  @override
  Future<String?> getRole() => local.getRole();

  @override
  Future<void> logout() async {
    await remote.logout();   
    await local.logout();  
  }
}
