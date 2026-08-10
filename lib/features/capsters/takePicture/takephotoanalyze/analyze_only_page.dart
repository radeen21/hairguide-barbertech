import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/camera_frame_painter.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/presentation/take_photo_controller.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/presentation/take_photo_state.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/takephotoanalyze/analyze_result_page.dart';

class AnalyzeOnlyPage extends StatefulWidget {
  final TakePhotoController controller;

  const AnalyzeOnlyPage({super.key, required this.controller});

  @override
  State<AnalyzeOnlyPage> createState() => _AnalyzeOnlyPageState();
}

class _AnalyzeOnlyPageState extends State<AnalyzeOnlyPage> {
  CameraController? cameraController;
  File? _capturedPhoto;

  bool isUploading = false;
  bool isCapturing = false;

  final faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final frontCamera =
        cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);

    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await cameraController!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    cameraController?.dispose();
    faceDetector.close();
    super.dispose();
  }

  // =====================
  // 📸 CAPTURE
  // =====================
  Future<void> _capturePhoto() async {
    if (cameraController == null ||
        !cameraController!.value.isInitialized) return;

    setState(() => isCapturing = true);

    try {
      final picture = await cameraController!.takePicture();
      final file = File(picture.path);

      await faceDetector.processImage(InputImage.fromFile(file));

      setState(() => _capturedPhoto = file);
    } finally {
      if (mounted) setState(() => isCapturing = false);
    }
  }

  // =====================
  // ☁️ UPLOAD
  // =====================
  Future<void> _uploadPhoto() async {
    if (_capturedPhoto == null) return;

    setState(() => isUploading = true);

    try {
      await widget.controller.uploadPhoto(
        path: _capturedPhoto!.path,
        serviceId: '',
      );

      final state = widget.controller.state;

      if (state is TakePhotoSuccess) {
        final analyze = state.analyzeResponse["data"];
        final bytes = await _capturedPhoto!.readAsBytes();

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AnalyzeResultPage(
              analyzeData: analyze,
              userPhoto: bytes,
            ),
          ),
        );

        setState(() {
          _capturedPhoto = null;
          cameraController?.resumePreview();
        });
      }
    } finally {
      if (mounted) setState(() => isUploading = false);
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
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "CUSTOMER PROFILE",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// =====================
                      /// 📷 FRAME (FIX SIZE)
                      /// =====================
                      Container(
                        width: 353, // ✅ FIX
                        height: 353, // ✅ FIX
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20), // ✅ FIX
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: isPreview
                                  ? Image.file(
                                      _capturedPhoto!,
                                      fit: BoxFit.cover,
                                    )
                                  : cameraController?.value.isInitialized ==
                                          true
                                      ? CameraPreview(cameraController!)
                                      : const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                            ),
                            CustomPaint(
                              painter: CameraFramePainter(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Ambil foto wajah depan",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: isPreview
                    ? Row(
                        children: [
                          Expanded(
                            child: _buttonGrey("Ulangi", () {
                              setState(() => _capturedPhoto = null);
                              cameraController?.resumePreview();
                            }),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _button("Analyze", _uploadPhoto),
                          ),
                        ],
                      )
                    : _button("Ambil Foto", _capturePhoto),
              ),
            ],
          ),
        ),

        // =====================
        // LOADING OVERLAY
        // =====================
        if (isCapturing || isUploading)
          Container(
            color: Colors.black.withOpacity(0.6),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFFF6AD03)),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buttonGrey(String text, VoidCallback onPressed) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
