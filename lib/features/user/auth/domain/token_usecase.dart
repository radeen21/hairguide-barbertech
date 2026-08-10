import 'package:hairguide_barberpedia/features/user/auth/domain/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<void> call() {
    return repository.refreshToken();
  }
}
