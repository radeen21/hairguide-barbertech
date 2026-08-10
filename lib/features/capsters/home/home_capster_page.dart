import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/core/di/service_locator.dart';
import 'package:hairguide_barberpedia/core/dio_client.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/customer_record_page.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/presentation/capster_history_controller.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/domain/take_and_analyze_photo_usecase.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/data/gromming_service_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/data/gromming_service_repository_impl.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/domain/gromming_service_usecase.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/gromming_service_page.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/presentation/gromming_service_controller.dart';

class HomeCapsterPage extends StatefulWidget {
  final String capsterName;
  final TakeAndAnalyzePhotoUseCase takePhotoUseCase;

  const HomeCapsterPage({
    super.key,
    required this.capsterName,
    required this.takePhotoUseCase,
  });

  @override
  State<HomeCapsterPage> createState() => _HomeCapsterPageState();
}

class _HomeCapsterPageState extends State<HomeCapsterPage> {
  late final CapsterHistoryController _historyController;

  @override
  void initState() {
    super.initState();
    _historyController = locator<CapsterHistoryController>();
    _historyController.fetch();
    debugPrint("🚀 Fetch capster history...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                /// ROW LOGO + NOTIF
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("assets/icon_barbertech.png", width: 50),
                    const Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// GREETINGS
                Text(
                  "Halo Capster, ${widget.capsterName}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// TARGET CONTAINER
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Target Achievement",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Target pendapatan (12 juta)",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      "On Track",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  "10% / ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF6AD03),
                                  ),
                                ),
                                Text(
                                  "10% (Minimal Target)",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// SERVICE CONTAINER
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GrommingServicesPage(
                          controller: GrommingServicesController(
                            GetGroomingServicesUseCase(
                              GrommingServiceRepositoryImpl(
                                GrommingServiceRemoteDataSource(
                                  DioClient.create(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 230,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Image.asset(
                              "assets/banner_service.png",
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              color: const Color(0xFF141414),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Services",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// 🔥 LATEST ACTIVITY
                const SizedBox(height: 30),
                _latestActivitySection(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================
  // 🔥 LATEST ACTIVITY
  // ============================
  Widget _latestActivitySection() {
    return AnimatedBuilder(
      animation: _historyController,
      builder: (_, __) {
        if (_historyController.isLoading) {
          return const SizedBox(
            height: 120,
            child: Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
          );
        }

        final items = _historyController.histories;

        if (items.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Belum ada aktivitas",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        final top3 = items.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Latest Activity",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CustomerRecordPage(
                          controller: _historyController,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Text(
                        "Lihat semua",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// LIST
            ...top3.map((item) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        /// LEFT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.memberName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.lastServiceType ?? "-",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// RIGHT STATUS
                        _statusBadge(item.serviceStatusLabel),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: Colors.white12),
                ],
              );
            }).toList(),
          ],
        );
      },
    );
  }

  // ============================
  // STATUS BADGE
  // ============================
  Widget _statusBadge(String? status) {
  final normalized = status?.toUpperCase().trim();

  final isDone = normalized == "COMPLETED" || normalized == "DONE";

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: isDone
          ? Colors.green.withOpacity(0.2)
          : Colors.orange.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      normalized ?? "-",
      style: TextStyle(
        color: isDone ? Colors.green : Colors.orange,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    ),
  );
}

}
