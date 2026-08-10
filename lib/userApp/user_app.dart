import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hairguide_barberpedia/core/di/service_locator.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/domain/take_and_analyze_photo_usecase.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/login_usecase.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/logout/usecase/logout_usecase.dart';
import 'package:hairguide_barberpedia/features/user/auth/login_page.dart';
import 'package:hairguide_barberpedia/features/user/auth/presentation/register/register_controller.dart';
import 'package:hairguide_barberpedia/features/user/auth/register_page.dart';
import 'package:hairguide_barberpedia/features/user/history/presentation/history_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/home_page.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/presentation/get_point_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/presentation/voucher/voucher_controller.dart';
import 'package:hairguide_barberpedia/features/user/scanbarcode/presentation/scan_controller.dart';
import 'package:hairguide_barberpedia/onboarding/onboarding_page.dart';

class UserApp extends StatelessWidget {
  const UserApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: "HairGuide",
      debugShowCheckedModeBanner: false,
      initialRoute: "/onboarding",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/onboarding":
            return MaterialPageRoute(builder: (_) => OnboardingPage());

          case "/login":
            return MaterialPageRoute(
              builder: (_) => LoginPage(
                loginUseCase: locator<LoginUseCase>(),
                logoutUseCase: locator<LogoutUseCase>(),
                registerController: locator<RegisterController>(),
                pointsController: locator<PointsController>(),
                takeAndAnalyzePhotoUseCase:
                    locator<TakeAndAnalyzePhotoUseCase>(),
                historyController: locator<HistoryController>(),
                voucherController: locator<VoucherController>(),
                scanController: locator<ScanController>(),
              ),
            );

          case "/register":
            return MaterialPageRoute(
              builder: (_) =>
                  RegisterPage(controller: locator<RegisterController>()),
            );

          case "/home":
            return MaterialPageRoute(
              builder: (_) => HomePage(
                userName: "User",
                pointsController: locator<PointsController>(),
                voucherController: locator<VoucherController>(),
              ),
            );

          default:
            return MaterialPageRoute(builder: (_) => OnboardingPage());
        }
      },
    );
  }
}
