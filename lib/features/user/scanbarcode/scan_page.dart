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
    _scannerController.start();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcode = capture.barcodes.first;
    final value = barcode.rawValue;

    if (value == null || value.isEmpty) return;

    setState(() => _isProcessing = true);

    _scannerController.stop();

    debugPrint("QR RESULT: $value");

    try {
      await widget.controller.scan(value);

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Scan Berhasil"),
          content: Text(
            "Session berhasil dibuat\n\n"
            "Status: ${widget.controller.session?.status ?? "-"}",
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.of(context, rootNavigator: true).pop();

                Navigator.pop(context);

                setState(() {
                  _isProcessing = false; 
                });

                _scannerController.start();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint("SCAN ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal scan QR")));

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

            Expanded(
              child: Center(
                child: SizedBox(
                  width: 353,
                  height: 353,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: MobileScanner(
                          controller: _scannerController,
                          onDetect: _onDetect,
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFF6AD03),
                            width: 2,
                          ),
                        ),
                      ),

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
