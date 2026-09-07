import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/core/di/service_locator.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/customer_record_page.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/presentation/capster_history_controller.dart';
import 'package:hairguide_barberpedia/features/capsters/home/home_capster_page.dart';
import 'package:hairguide_barberpedia/features/capsters/profile/akun_capster_page.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/domain/take_and_analyze_photo_usecase.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/logout/logout_controller.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/logout/usecase/logout_usecase.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/presentation/capster_controller.dart';

class CapsterRootPage extends StatefulWidget {
  final String capsterName;
  final TakeAndAnalyzePhotoUseCase takePhotoUseCase;
  final LogoutUseCase logoutUseCase;
  // final CapsterHistoryController capsterHistoryController;

  const CapsterRootPage({
    super.key,
    required this.capsterName,
    required this.takePhotoUseCase,
    required this.logoutUseCase,
    // required this.capsterHistoryController,
  });

  @override
  State<CapsterRootPage> createState() => _CapsterRootPageState();
}

class _CapsterRootPageState extends State<CapsterRootPage> {
  int _currentIndex = 0;

  late final CapsterHistoryController _historyController;

  @override
  void initState() {
    super.initState();
    _historyController = locator<CapsterHistoryController>();
    _historyController.fetch();

    debugPrint("📦 CapsterHistoryController initialized in RootPage");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: IndexedStack(
        index: _currentIndex,
        children: [

          HomeCapsterPage(
            capsterName: widget.capsterName,
            takePhotoUseCase: widget.takePhotoUseCase,
          ),

          CustomerRecordPage(
            controller: _historyController,
          ),

          AkunCapsterPage(
            capsterName: widget.capsterName, logoutUseCase: widget.logoutUseCase,
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFFF6AD03),
        unselectedItemColor: Colors.white38,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Customer Record",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Akun",
          ),
        ],
      ),
    );
  }
}
