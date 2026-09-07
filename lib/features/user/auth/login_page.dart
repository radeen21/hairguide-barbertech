import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hairguide_barberpedia/features/capsters/capster_root_page.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/presentation/capster_history_controller.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/domain/take_and_analyze_photo_usecase.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/login_usecase.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/logout/usecase/logout_usecase.dart';
import 'package:hairguide_barberpedia/features/user/auth/presentation/register/register_controller.dart';
import 'package:hairguide_barberpedia/features/user/auth/register_page.dart';
import 'package:hairguide_barberpedia/features/user/dashboard/home_root.dart';
import 'package:hairguide_barberpedia/features/user/history/presentation/history_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/presentation/capster_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/presentation/get_point_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/presentation/voucher/voucher_controller.dart';
import 'package:hairguide_barberpedia/features/user/scanbarcode/presentation/scan_controller.dart';

class LoginPage extends StatefulWidget {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final TakeAndAnalyzePhotoUseCase takeAndAnalyzePhotoUseCase;
  final RegisterController registerController;
  final PointsController pointsController;
  final HistoryController historyController;
  final VoucherController voucherController;
  final ScanController scanController;
  // final CapsterHistoryController capsterHistoryController;

  const LoginPage({
    super.key,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.takeAndAnalyzePhotoUseCase,
    required this.registerController,
    required this.pointsController,
    required this.historyController,
    required this.voucherController,
    required this.scanController
    // required this.capsterHistoryController,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  String? _errorMessage;
  bool _hasError = false;

  bool get _isFormValid =>
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    debugPrint(" RegisterPage OPENED");
    // forcePortrait();
    _emailController.addListener(
      () => setState(() {
        _hasError = false;
        _errorMessage = null;
      }),
    );
    _passwordController.addListener(
      () => setState(() {
        _hasError = false;
        _errorMessage = null;
      }),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    _showLoading(context);

    try {
      final userEntity = await widget.loginUseCase(email, password);

      _hideLoading(context);

      final role = userEntity.role;
      final fullName = userEntity.fullName;

      if (role == "capster") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CapsterRootPage(
              capsterName: fullName,
              takePhotoUseCase: widget.takeAndAnalyzePhotoUseCase,
              logoutUseCase: widget.logoutUseCase,
              // capsterController: widget.capsterController,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeRoot(
              userName: fullName,
              logoutUseCase: widget.logoutUseCase,
              pointsController: widget.pointsController,
              historyController: widget.historyController,
              voucherController: widget.voucherController, 
              scanController: widget.scanController,
              
            ),
          ),
        );
      }
    } catch (e) {
      _hideLoading(context); 

      setState(() {
        _hasError = true; 
        _errorMessage = "Email atau password salah"; 
      });
    }
  }

  @override
void dispose() {
  debugPrint("📱 RegisterPage CLOSED");
  // forceLandscape();
  // forcePortrait();
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              Center(
                child: Image.asset("assets/logo_barbertech.png", width: 120),
              ),

              const SizedBox(height: 40),

              /// EMAIL
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: _hasError ? Colors.red : Colors.white70, 
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _hasError ? Colors.red : Colors.white24, 
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _hasError ? Colors.red : Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// PASSWORD
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: _hasError ? Colors.red : Colors.white70, 
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _hasError ? Colors.red : Colors.white24, 
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _hasError ? Colors.red : Colors.white, 
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Lupa password?",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              if (_hasError && _errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),

              const SizedBox(height: 10),

              /// LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid
                        ? const Color(0xFFF6AD03) // aktif
                        : const Color(0xFF444444), // non-aktif
                    foregroundColor: const Color(0xFF010101),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: _isFormValid ? 2 : 0,
                  ),
                  onPressed: () {
                    if (!_isFormValid) return;
                    _handleLogin();
                  },
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                      letterSpacing: 2,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(children: const [Expanded(child: Divider(thickness: 1))]),

              const SizedBox(height: 60),

              /// REGISTER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Belum punya akun? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RegisterPage(
                            controller: widget.registerController,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Daftar di sini",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        )
      ),
    );
  }
}

void _showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (_) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFF6AD03)),
      );
    },
  );
}

void _hideLoading(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}


Future<void> forcePortrait() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

Future<void> forceLandscape() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
  ]);
}