import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/domain/take_and_analyze_photo_usecase.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/logout/usecase/logout_usecase.dart';
import 'package:hairguide_barberpedia/features/user/booking/booking_page.dart';
import 'package:hairguide_barberpedia/features/user/history/history_page.dart';
import 'package:hairguide_barberpedia/features/user/history/presentation/history_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/home_page.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/presentation/get_point_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/presentation/voucher/voucher_controller.dart';
import 'package:hairguide_barberpedia/features/user/profile/profile_page.dart';
import 'package:hairguide_barberpedia/features/user/scanbarcode/presentation/scan_controller.dart';
import 'package:hairguide_barberpedia/features/user/scanbarcode/scan_page.dart';

class HomeRoot extends StatefulWidget {
  final String userName;
  final LogoutUseCase logoutUseCase;
  final PointsController pointsController;
  final HistoryController historyController;
  final VoucherController voucherController;
  final ScanController scanController;

  const HomeRoot({
    super.key,
    required this.userName,
    required this.logoutUseCase,
    required this.pointsController,
    required this.historyController,
    required this.voucherController,
    required this.scanController,
  });

  @override
  State<HomeRoot> createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
  int _currentIndex = 0;

  final List<IconData> _icons = [
    Icons.home,
    Icons.book_online,
    // Icons.qr_code_scanner,
    Icons.history,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // BODY GANTI-GANTI HALAMAN
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomePage(
            userName: widget.userName,
            pointsController: widget.pointsController,
            voucherController: widget.voucherController,
          ),
          BookingPage(),
          // ScanPage(controller: widget.scanController),
          // Center(child: Text("History Page", style: TextStyle(color: Colors.white))),
          HistoryPage(controller: widget.historyController),
          ProfilePage(
            userName: widget.userName,
            logoutUseCase: widget.logoutUseCase,
          ),
        ],
      ),

      // BOTTOM BAR
      bottomNavigationBar: 
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color: Colors.white24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() => _currentIndex = index);
              },
              child: _navItem(
                icon: _icons[index],
                // label: ["Home", "Booking", "Scan", "History", "Profile"][index],
                label: ["Home", "Booking", "History", "Profile"][index],
                active: _currentIndex == index,
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool active,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? Colors.white : Colors.white38, size: 26),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.white38,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
