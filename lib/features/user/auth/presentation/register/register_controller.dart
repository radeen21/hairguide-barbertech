import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/register/register_usecase.dart';

class RegisterController extends ChangeNotifier {
  final RegisterUseCase registerUseCase;

  bool isLoading = false;

  RegisterController({required this.registerUseCase});

  Future<void> register({
  required String email,
  required String phone,
  required String password,
  required String name,
  required String dob,
  required BuildContext context,
}) async {

  /// 🔥 VALIDASI DULU SEBELUM LOADING
  if (password.length < 8) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Password minimal 8 karakter"),
        backgroundColor: Colors.red,
      ),
    );
    return; // stop disini
  }

  try {
    isLoading = true;
    notifyListeners();

    final user = await registerUseCase(
      email: email,
      phone: phone,
      password: password,
      name: name,
      dob: dob,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Registrasi berhasil: ${user.fullName}"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacementNamed(context, "/login");
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Gagal register: $e"),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

}
