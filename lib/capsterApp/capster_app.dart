import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hairguide_barberpedia/capsterApp/auth/capster_login_page.dart';

class CapsterApp extends StatefulWidget {
  const CapsterApp({super.key});

  @override
  State<CapsterApp> createState() => _CapsterAppState();
}

class _CapsterAppState extends State<CapsterApp> {

  @override
  void initState() {
    super.initState();

    /// 🔥 LOCK LANDSCAPE KHUSUS CAPSTER
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),

      /// ✅ LOGIN DULU
      // home: const CapsterLoginPage(loginUseCase: null,, logoutUseCase: null,, takeAndAnalyzePhotoUseCase: null,, pointsController: null,, historyController: null,, voucherController: null,, scanController: null,),
    );
  }
}
