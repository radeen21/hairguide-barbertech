import 'package:hairguide_barberpedia/features/user/auth/domain/auth_repository.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/entities/user_entity.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/session/auth_session_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;
  final AuthSessionRepository sessionRepository;

  LoginUseCase({
    required this.authRepository,
    required this.sessionRepository,
  });

  Future<UserEntity> call(String email, String password) async {
    final user = await authRepository.login(email, password);

    await sessionRepository.saveSession(
      userId: user.id,
      sessionToken: user.sessionToken,
      refreshToken: user.refreshToken,
      sessionExpiresAt: user.sessionExpiresAt,
      refreshExpiresAt: user.refreshExpiresAt,
      role: user.role,
      point: user.point,
    );

    return user;
  }
}
