import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/core/dio_client.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/add-on/hair_guide_add_on_page.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/camera_frame_painter.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/domain/gromming_service_entity.dart';


class TakeAddOnPicturePage extends StatefulWidget {
  final GrommingServiceEntity service;
  final Map<String, dynamic> addOnPayload;

  const TakeAddOnPicturePage({
    super.key,
    required this.service,
    required this.addOnPayload,
  });

  @override
  State<TakeAddOnPicturePage> createState() => _TakeAddOnPicturePageState();
}

class _TakeAddOnPicturePageState extends State<TakeAddOnPicturePage> {
  CameraController? _cameraController;
  File? _capturedPhoto;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final backCamera =
        cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back);

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // 📸 Ambil foto
  Future<void> _capturePhoto() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized) return;

    final picture = await _cameraController!.takePicture();
    setState(() => _capturedPhoto = File(picture.path));
  }

  // ☁️ Upload + Generate Add-On
  Future<void> _submitAddOn() async {
    if (_capturedPhoto == null) return;

    setState(() => _isLoading = true);

    try {
      final dio = DioClient.create();

      // ==========================
      // 1️⃣ UPLOAD PHOTO
      // ==========================
      final formData = FormData.fromMap({
        "photo": await MultipartFile.fromFile(_capturedPhoto!.path),
      });

      final uploadRes = await dio.post("/photos", data: formData);
      final photoId = uploadRes.data["data"]["id"];

      // ==========================
      // 2️⃣ GENERATE ADD-ON
      // ==========================
      final generateRes = await dio.post(
        "/generate-image/add-on",
        data: {
          "photo_id": photoId,
          "add_on": widget.addOnPayload,
        },
      );

      final rawUrl = generateRes.data["data"]?["url"];
      if (rawUrl == null) {
        throw Exception("URL hasil add-on tidak ditemukan");
      }

      // 🔥 FIX UTAMA
      final imageUrl = "${dio.options.baseUrl}/photos$rawUrl";

      debugPrint("🖼 ADD-ON IMAGE URL: $imageUrl");

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HairGuideAddOnPage(
            imageUrl: imageUrl,
          ),
        ),
      );
    } catch (e) {
      debugPrint("❌ ERROR ADD-ON: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPreview = _capturedPhoto != null;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(widget.service.name),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 314,
                        height: 314,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: isPreview
                                  ? Image.file(_capturedPhoto!,
                                      fit: BoxFit.cover)
                                  : (_cameraController?.value.isInitialized ??
                                          false)
                                      ? CameraPreview(_cameraController!)
                                      : const Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.white),
                                        ),
                            ),
                            CustomPaint(painter: CameraFramePainter()),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Ambil foto rambut customer",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: isPreview
                      ? Row(
                          children: [
                            Expanded(
                              child: _buttonGrey("Ulangi", () {
                                setState(() => _capturedPhoto = null);
                                _cameraController?.resumePreview();
                              }),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _button(
                                  "Generate Add-On", _submitAddOn),
                            ),
                          ],
                        )
                      : _button("Ambil Foto", _capturePhoto),
                ),
              ],
            ),
          ),
        ),

        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.6),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
          ),
      ],
    );
  }

  Widget _button(String text, VoidCallback onPressed) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF6AD03),
          foregroundColor: Colors.black,
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buttonGrey(String text, VoidCallback onPressed) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
