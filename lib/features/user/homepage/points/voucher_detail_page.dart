import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/domain/voucher/redeem_voucher_usecase.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/domain/voucher/voucher_entity.dart';

class DetailVoucherPage extends StatefulWidget {
  final VoucherEntity voucher;
  final RedeemVoucherUseCase redeemUseCase;

  const DetailVoucherPage({
    super.key,
    required this.voucher,
    required this.redeemUseCase,
  });

  @override
  State<DetailVoucherPage> createState() => _DetailVoucherPageState();
}

class _DetailVoucherPageState extends State<DetailVoucherPage> {
  bool _isRedeeming = false;

  Future<void> _handleRedeem() async {
    setState(() => _isRedeeming = true);

    try {
      await widget.redeemUseCase.call(widget.voucher.code);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Voucher berhasil diredeem "),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal redeem voucher: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isRedeeming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "DETAIL VOUCHER",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/logo_barberpedia.png",
                      height: 80,
                    ),
                  ),
                ),

                const SizedBox(height: 16),


                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.voucher.code,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${widget.voucher.pointsRequired} Point",
                        style: const TextStyle(
                          color: Color(0xFFF6AD03),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const SingleChildScrollView(
                      child: Text(
                        "Voucher ini dapat digunakan untuk mendapatkan potongan harga sesuai dengan ketentuan yang berlaku. Pastikan voucher masih aktif sebelum digunakan.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF6AD03),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    onPressed: _isRedeeming ? null : _handleRedeem,
                    child: const Text(
                      "Redeem",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (_isRedeeming)
          Container(
            color: Colors.black.withOpacity(0.6),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            ),
          ),
      ],
    );
  }
}
