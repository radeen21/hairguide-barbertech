import 'package:hairguide_barberpedia/features/user/auth/domain/logout/usecase/logout_usecase.dart';

class ProfileController {
  final LogoutUseCase logoutUseCase;

  ProfileController(this.logoutUseCase);

  Future<void> logout() async {
    await logoutUseCase();
  }
}
