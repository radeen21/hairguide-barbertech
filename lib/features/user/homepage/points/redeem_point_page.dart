import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/core/di/service_locator.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/session/auth_session_repository.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/domain/voucher/redeem_voucher_usecase.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/domain/voucher/voucher_entity.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/presentation/voucher/voucher_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/voucher_detail_page.dart';

class RedeemPointPage extends StatefulWidget {
  final int points;
  final VoucherController controller;

  const RedeemPointPage({
    super.key,
    required this.points,
    required this.controller,
  });

  @override
  State<RedeemPointPage> createState() => _RedeemPointPageState();
}

class _RedeemPointPageState extends State<RedeemPointPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "TUKAR POINT",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _pointCard(widget.points),
          ),

          const SizedBox(height: 24),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Tukarkan Point Anda",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: AnimatedBuilder(
              animation: widget.controller,
              builder: (_, __) {
                if (widget.controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                }

                if (widget.controller.error != null) {
                  return Center(
                    child: Text(
                      widget.controller.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final List<VoucherEntity> items = widget.controller.vouchers;

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      "Voucher belum tersedia",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    final voucher = items[index];

                    return _promoItem(
                      title: "${voucher.code} • ${voucher.discountPercent}%",
                      point: voucher.pointsRequired,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailVoucherPage(
                              voucher: voucher,
                              redeemUseCase: locator<RedeemVoucherUseCase>(),
                            ),
                          ),
                        );

                        if (result == true) {
                          widget.controller
                              .fetch(); // refresh list setelah redeem
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _pointCard(int points) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF2C2C2C), Color(0xFF111111)],
          ),
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

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // LEFT TEXT
                    const Text(
                      "Point Anda",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),

                    const Spacer(),

                    // RIGHT POINT VALUE
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${locator<AuthSessionRepository>().getPoint()}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Text(
                            "pts",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _promoItem({
    required String title,
    required int point,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // LOGO
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: const Icon(Icons.local_offer, color: Color(0xFFF6AD03)),
            ),

            const SizedBox(width: 12),

            // TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 12),
                      children: [
                        const TextSpan(
                          text: "Point yang ditukar : ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextSpan(
                          text: "$point Point",
                          style: const TextStyle(
                            color: Color(0xFFF6AD03),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
