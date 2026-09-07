import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/core/di/service_locator.dart';
import 'package:hairguide_barberpedia/core/dio_client.dart';
import 'package:hairguide_barberpedia/core/env/env_config.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/domain/take_and_analyze_photo_usecase.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/presentation/take_photo_controller.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/take_photo_page.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/takephotoanalyze/analyze_only_page.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/session/auth_session_repository.dart';
import 'package:hairguide_barberpedia/features/user/history/presentation/history_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/capster_list_page.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/data/capster_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/data/capster_repository_impl.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/domain/get_capster_usecase.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/presentation/capster_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/data/gromming_service_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/data/gromming_service_repository_impl.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/domain/gromming_service_usecase.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/domain/resolve_gromming_service_flow.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/gromming_service_page.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/presentation/gromming_service_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/presentation/get_point_controller.dart';

import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/core/dio_client.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/capster_list_page.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/data/capster_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/data/capster_repository_impl.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/domain/get_capster_usecase.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/presentation/capster_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/data/gromming_service_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/data/gromming_service_repository_impl.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/domain/gromming_service_usecase.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/gromming_service_page.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/presentation/gromming_service_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/presentation/get_point_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/presentation/voucher/voucher_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/redeem_point_page.dart';
import 'package:hairguide_barberpedia/features/user/homepage/rating/rating_box.dart';
import 'package:hairguide_barberpedia/features/user/review/presentation/review_controller.dart';
import 'package:hairguide_barberpedia/features/user/review/review_capster_card.dart';

class HomePage extends StatefulWidget {
  final String userName;
  final PointsController pointsController;
  final VoucherController voucherController;

  const HomePage({
    super.key,
    required this.userName,
    required this.pointsController,
    required this.voucherController,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final CapsterController _capsterController;
  late final HistoryController _historyController;

  bool _showReview = true;

  late final ReviewController _reviewController;

  @override
  void initState() {
    super.initState();
    widget.pointsController.fetchPoints();

    final session = locator<AuthSessionRepository>();

    debugPrint("HOME SESSION CHECK");
    debugPrint("   userId = ${session.getUserId()}");
    debugPrint("   role   = ${session.getRole()}");
    debugPrint("   token  = ${session.getSessionToken()}");
    debugPrint(
      "   point  = ${session.getPoint()}",
    ); 
    debugPrint("   login  = ${session.isLoggedIn()}");

    _capsterController = CapsterController(
      GetCapstersUseCase(
        CapsterRepositoryImpl(CapsterRemoteDataSource(DioClient.create())),
      ),
    );

    debugPrint("CapsterController CREATED");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(" CALL fetchCapsters()");
      _capsterController.fetchCapsters();
    });

     _historyController = locator<HistoryController>();

    _historyController.fetchHistories();

  }

  @override
  void dispose() {
    _capsterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: widget.pointsController,
          builder: (_, __) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/logo_barbertech.png", height: 40),
                      const Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// GREETING
                  Text(
                    "Selamat datang, ${widget.userName}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// POINTS CARD
                  _pointsCard(),

                  const SizedBox(height: 40),

                  /// MENU ATAS
                  Row(
                    children: [
                      Expanded(child: _builCustomerProfile()),
                      const SizedBox(width: 14),
                      Expanded(child: _buildGroomingMenu()),
                    ],
                  ),

                  const SizedBox(height: 32),

                  /// PRODUCT
                  _sectionTitle(title: "Product", onClick: () {}),
                  const SizedBox(height: 14),
                  _productList(),

                  const SizedBox(height: 32),

                  AnimatedBuilder(
                    animation: _historyController,
                    builder: (_, __) {
                      if (_historyController.isLoading) {
                        return const SizedBox();
                      }

                      if (_historyController.histories.isEmpty) {
                        return const SizedBox();
                      }

                      final history = _historyController.histories.first;

                      return _reviewFromCapsterList();
                    },
                  ),

                  const SizedBox(height: 32),

                  /// CAPSTER
                  _sectionTitle(
                    title: "Daftar Capster",
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CapsterListPage(
                            controller: locator<CapsterController>(),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 14),
                  _capsterList(),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _reviewFromCapsterList() {
  return AnimatedBuilder(
    animation: Listenable.merge([
      _historyController,
      _capsterController,
    ]),
    builder: (_, __) {

      if (_historyController.isLoading ||
          _capsterController.isLoading) {
        return const SizedBox();
      }

      if (_historyController.histories.isEmpty) {
        return const SizedBox();
      }

      if (_capsterController.capsters.isEmpty) {
        return const SizedBox();
      }

      final history = _historyController.histories.first;

      final capster = _capsterController.capsters.firstWhere(
        (c) => c.id == history.id,
        orElse: () => _capsterController.capsters.first,
      );

      if ((capster.rating ?? 0) > 0) {
        return const SizedBox();
      }

      return ReviewRatingBox(
        capsterId: capster.id,
        capsterName: capster.name ?? "-",
      );
    },
  );
}



  Widget _buildGroomingMenu() {
    final menu = _menuBox(
      assetPath: "assets/banner_grooming.png",
      title: "Grooming Service",
      height: 240,
      imageHeight: 140,
      isBold: true,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GrommingServicesPage(
              controller: GrommingServicesController(
                GetGroomingServicesUseCase(
                  GrommingServiceRepositoryImpl(
                    GrommingServiceRemoteDataSource(DioClient.create()),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: menu,
    );
  }

  Widget _builCustomerProfile() {
    final menu = _menuBox(
      assetPath: "assets/banner_hairguide.png",
      title: "Customer Profile",
      height: 240,
      imageHeight: 140,
      isBold: true,
    );

    return GestureDetector(
      onTap: () {
        final session = locator<AuthSessionRepository>();
        final role = session.getRole();

        debugPrint("ROLE LOGIN = $role");

        if (role == "user") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AnalyzeOnlyPage(controller: locator<TakePhotoController>()),
            ),
          );
          return;
        }

        final takePhotoController = locator<TakePhotoController>();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GrommingServicesPage(
              controller: locator<GrommingServicesController>(),
            ),
          ),
        );
      },
      child: menu,
    );
  }

  Widget _pointsCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RedeemPointPage(
              points: widget.pointsController.points,
              controller: widget.voucherController,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Image.asset(
                  "assets/icon_element_container.png",
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.pointsController.isLoading
                        ? const CircularProgressIndicator(color: Colors.orange)
                        : Text(
                            "${locator<AuthSessionRepository>().getPoint()} pts",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const Row(
                      children: [
                        Text(
                          "Tukarkan poin",
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFFFFFFF),
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _productBox(assetPath: "assets/icon_can.png", title: "Pomade"),
          _productBox(assetPath: "assets/icon_pomade.png", title: "Mask"),
        ],
      ),
    );
  }

  Widget _capsterList() {
    return AnimatedBuilder(
      animation: _capsterController,
      builder: (_, __) {
        debugPrint("CAPSTER LIST BUILD");
        debugPrint("   loading = ${_capsterController.isLoading}");
        debugPrint("   total   = ${_capsterController.capsters.length}");

        if (_capsterController.isLoading) {
          return const SizedBox(
            height: 160,
            child: Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
          );
        }

        final capsters = _capsterController.capsters;

        if (capsters.isEmpty) {
          return const SizedBox(
            height: 120,
            child: Center(
              child: Text(
                "Belum ada capster tersedia",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final capster in capsters) ...[
                _capsterBox(
                  assetPath: buildCapsterPhotoUrl(capster.photoUrl),
                  name: capster.name ?? "-",
                  rating: (capster.rating ?? 0).toDouble(),
                ),
                const SizedBox(width: 14),
              ],
            ],
          ),
        );
      },
    );
  }
}

Widget _menuBox({
  required String assetPath,
  required String title,
  double height = 180,
  double imageHeight = 90,
  bool isBold = false,
}) {
  return Container(
    height: height,
    decoration: BoxDecoration(
      color: Colors.grey.shade900,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: SizedBox(
            height: imageHeight,
            width: double.infinity,
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _sectionTitle({required String title, required VoidCallback onClick}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      GestureDetector(
        onTap: onClick,
        child: Row(
          children: const [
            Text("Lihat semua", style: TextStyle(color: Color(0xFFFFFFFF))),
            SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, color: Color(0xFFFFFFFF), size: 14),
          ],
        ),
      ),
    ],
  );
}

Widget _productBox({required String assetPath, required String title}) {
  return Container(
    width: 120,
    padding: const EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(assetPath, width: 50, height: 50),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    ),
  );
}

Widget _capsterBox({
  required String assetPath,
  required String name,
  required double rating,
  double cropFactor = 0.55,
  double width = 140,
  double height = 144,
}) {
  final double imageHeight = height * 0.65;

  final String imagePath = assetPath.trim();

  /// kalau kosong → langsung pakai default asset
  final bool isEmptyImage = imagePath.isEmpty;

  /// cek apakah network image
  final bool isNetworkImage = !isEmptyImage && imagePath.startsWith("http");

  debugPrint("IMAGE CHECK:");
  debugPrint("   raw = [$assetPath]");
  debugPrint("   trim = [$imagePath]");
  debugPrint("   isNetwork = $isNetworkImage");
  debugPrint("   isEmpty = $isEmptyImage");

  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.grey.shade900,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: imageHeight,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: cropFactor,
                    child: _buildImage(
                      isNetworkImage: isNetworkImage,
                      isEmptyImage: isEmptyImage,
                      imagePath: imagePath,
                    ),
                  ),
                ),

                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const Spacer(),
        const SizedBox(height: 12),
      ],
    ),
  );
}

Widget _buildImage({
  required bool isNetworkImage,
  required bool isEmptyImage,
  required String imagePath,
}) {

  if (isEmptyImage) {
    return Image.asset("assets/banner_grooming.png", fit: BoxFit.cover);
  }

  if (isNetworkImage) {
    return Image.network(
      imagePath,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
      errorBuilder: (_, error, __) {
        debugPrint("IMAGE NETWORK ERROR: $error");
        return Image.asset("assets/banner_grooming.png", fit: BoxFit.cover);
      },
    );
  }

  return Image.asset("assets/banner_grooming.png", fit: BoxFit.cover);
}

String buildCapsterPhotoUrl(String? photoPath) {
  if (photoPath == null) return "";

  final cleaned = photoPath.trim();
  if (cleaned.isEmpty) return "";

  if (cleaned.startsWith("http")) return cleaned;

  final cleanPath = cleaned.startsWith("/") ? cleaned.substring(1) : cleaned;

  final url = "${EnvConfig.baseUrl}/photos/$cleanPath";

  debugPrint("BUILD PHOTO URL:");
  debugPrint("   raw   = [$photoPath]");
  debugPrint("   clean = [$cleaned]");
  debugPrint("   final = [$url]");

  return url;
}
