import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/features/user/scanbarcode/presentation/scan_controller.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  final ScanController controller;

  const ScanPage({super.key, required this.controller});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final MobileScannerController _scannerController = MobileScannerController();

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _scannerController.start(); // ✅ PENTING: START CAMERA
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcode = capture.barcodes.first;
    final value = barcode.rawValue;

    if (value == null || value.isEmpty) return;

    setState(() => _isProcessing = true);

    /// stop kamera biar tidak scan berkali-kali
    _scannerController.stop();

    debugPrint("📦 QR RESULT: $value");

    try {
      /// 🔥 HIT API
      await widget.controller.scan(value);

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Scan Berhasil ✅"),
          content: Text(
            "Session berhasil dibuat\n\n"
            "Status: ${widget.controller.session?.status ?? "-"}",
          ),
          actions: [
            TextButton(
              onPressed: () {
                /// 1️⃣ Close dialog dulu
                // Navigator.of(context, rootNavigator: true).pop();

                /// 2️⃣ Close halaman scan
                Navigator.pop(context);

                setState(() {
                  _isProcessing = false; // ✅ STOP LOADING
                });

                _scannerController.start(); // ✅ OPTIONAL: resume scan
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint("❌ SCAN ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ Gagal scan QR")));

      /// restart scanner kalau gagal
      // _scannerController.start();

      setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================
            // TITLE
            // =====================
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Scan Barcode",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // =====================
            // CAMERA + FRAME
            // =====================
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 353,
                  height: 353,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      /// 📷 CAMERA
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: MobileScanner(
                          controller: _scannerController,
                          onDetect: _onDetect,
                        ),
                      ),

                      /// 🌫 OVERLAY GELAP
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      /// 🟨 BORDER
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFF6AD03),
                            width: 2,
                          ),
                        ),
                      ),

                      /// ⏳ LOADING SAAT SCAN
                      if (_isProcessing)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFF6AD03),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
