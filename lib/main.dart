import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:hairguide_barberpedia/core/di/service_locator.dart';
import 'package:hairguide_barberpedia/core/env/app_env.dart';
import 'package:hairguide_barberpedia/core/fcm/fcm_service.dart';
import 'package:hairguide_barberpedia/features/user/history/presentation/history_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/presentation/capster_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/presentation/voucher/voucher_controller.dart';
import 'package:hairguide_barberpedia/features/user/scanbarcode/presentation/scan_controller.dart';

// Firebase Options
import 'firebase_options.dart';

// ROUTES / PAGES
import 'package:hairguide_barberpedia/onboarding/onboarding_page.dart';
import 'package:hairguide_barberpedia/features/user/auth/login_page.dart';
import 'package:hairguide_barberpedia/features/user/auth/register_page.dart';
import 'package:hairguide_barberpedia/features/user/homepage/home_page.dart';

// CONTROLLERS
import 'package:hairguide_barberpedia/features/user/auth/presentation/register/register_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/presentation/get_point_controller.dart';

// USECASE
import 'package:hairguide_barberpedia/features/user/auth/domain/login_usecase.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/logout/usecase/logout_usecase.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/domain/take_and_analyze_photo_usecase.dart';

// SESSION
import 'package:hairguide_barberpedia/features/user/auth/domain/session/auth_session_repository.dart';
import 'package:hairguide_barberpedia/features/user/auth/data/session/auth_session_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Menangkap error dari Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);

    debugPrint('================ FLUTTER ERROR ================');
    debugPrint(details.exceptionAsString());
    debugPrintStack(stackTrace: details.stack);
    debugPrint('================================================');
  };

  // Menangkap error async yang tidak tertangkap.
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint('=============== UNCAUGHT ERROR ================');
    debugPrint(error.toString());
    debugPrintStack(stackTrace: stack);
    debugPrint('================================================');

    return true;
  };

  try {
    // =====================
    // ENV
    // =====================
    AppEnv.current = AppEnvironment.prod;
    debugPrint('✅ Environment berhasil diatur ke PROD');

    // =====================
    // INIT FIREBASE
    // =====================
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint('✅ Firebase berhasil diinisialisasi');

    // =====================
    // INIT GETIT
    // =====================
    setupLocator();

    debugPrint('✅ Service locator berhasil diinisialisasi');

    // =====================
    // LOAD SESSION
    // =====================
    final sessionRepo = locator<AuthSessionRepository>();

    if (sessionRepo is AuthSessionRepositoryImpl) {
      await sessionRepo.loadSession();
    }

    final sessionToken = sessionRepo.getSessionToken();

    debugPrint(
      '🔐 HAS SESSION TOKEN = ${sessionToken?.isNotEmpty == true}',
    );

    // =====================
    // INIT FCM
    // =====================
    //
    // FCM dibuat dalam try-catch terpisah supaya kegagalan notifikasi
    // tidak menyebabkan seluruh aplikasi berhenti.
    try {
      final fcmService = FcmService();

      await fcmService.requestPermission();
      debugPrint('✅ Permission notifikasi berhasil diproses');

      await fcmService.getToken();
      debugPrint('✅ Proses pengambilan FCM token selesai');

      fcmService.listenForegroundMessages();
      fcmService.listenTokenRefresh();

      debugPrint('✅ Listener FCM berhasil dijalankan');
    } catch (error, stackTrace) {
      debugPrint('⚠️ FCM gagal diinisialisasi');
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
    }

    // =====================
    // LOCK SCREEN ORIENTATION
    // =====================
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    debugPrint('✅ Orientasi layar berhasil diatur');

    // =====================
    // RUN APP
    // =====================
    runApp(const MyApp());
  } catch (error, stackTrace) {
    debugPrint('================ STARTUP ERROR ================');
    debugPrint(error.toString());
    debugPrintStack(stackTrace: stackTrace);
    debugPrint('================================================');

    runApp(
      StartupErrorApp(
        message: error.toString(),
      ),
    );
  }
}

class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({
    required this.message,
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HairGuide',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Aplikasi gagal dijalankan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Terjadi masalah saat menyiapkan aplikasi.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SelectableText(
                      message,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HairGuide',
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/onboarding':
            return MaterialPageRoute(
              builder: (_) => OnboardingPage(),
            );

          case '/login':
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

          case '/register':
            return MaterialPageRoute(
              builder: (_) => RegisterPage(
                controller: locator<RegisterController>(),
              ),
            );

          case '/home':
            return MaterialPageRoute(
              builder: (_) => HomePage(
                userName: 'User',
                pointsController: locator<PointsController>(),
                voucherController: locator<VoucherController>(),
              ),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => OnboardingPage(),
            );
        }
      },
    );
  }
}