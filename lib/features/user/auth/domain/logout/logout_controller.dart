import 'package:hairguide_barberpedia/features/user/auth/domain/logout/usecase/logout_usecase.dart';

class LogoutController {
  final LogoutUseCase logoutUseCase;

  LogoutController(this.logoutUseCase);

  Future<void> logout() async {
    await logoutUseCase();
  }
}
