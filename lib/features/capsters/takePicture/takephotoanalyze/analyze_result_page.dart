import 'dart:typed_data';
import 'package:flutter/material.dart';

class AnalyzeResultPage extends StatelessWidget {
  final Map<String, dynamic> analyzeData;
  final Uint8List? userPhoto;

  const AnalyzeResultPage({
    super.key,
    required this.analyzeData,
    this.userPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "CUSTOMER PROFILE",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          /// FOTO USER
          Center(
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white10,
              ),
              child: userPhoto != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(userPhoto!, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.person, color: Colors.white24, size: 48),
            ),
          ),

          const SizedBox(height: 24),

          /// FACE ANALYSIS
          _Accordion(
            title: "Hasil Analisis Wajah",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bullet("Bentuk Wajah", analyzeData["face_shape"] ?? "-"),
                _bullet(
                  "Analisis Bentuk Wajah",
                  analyzeData["face_analysis_result"] ?? "-",
                ),
                _bullet(
                  "Rekomendasi Gaya Rambut",
                  analyzeData["hair_recommendation"] ?? "-",
                ),
                _bullet("Hindari", analyzeData["hair_avoid"] ?? "-"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// HAIR LINE
          _Accordion(
            title: "Analisis Garis Rambut",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bullet("Deskripsi", analyzeData["hair_line"] ?? "-"),
                _bullet(
                  "Saran",
                  analyzeData["hair_line_suggestion"] ??
                      "Textured Top atau Pompadour",
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// HAIR TYPE
          _Accordion(
            title: "Analisis Jenis Rambut",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bullet("Kode", analyzeData["hair_type"]?["code"] ?? "-"),
                _bullet("Tipe", analyzeData["hair_type"]?["type"] ?? "-"),
                _bullet(
                  "Rekomendasi",
                  analyzeData["hair_type_recommendation"] ??
                      "French Crop, Korean Comma Hair, Side Part",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================
  // BULLET ITEM
  // =====================
  Widget _bullet(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.white70, height: 1.5),
          children: [
            TextSpan(
              text: "• $title:\n",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class _Accordion extends StatefulWidget {
  final String title;
  final Widget child;

  const _Accordion({required this.title, required this.child});

  @override
  State<_Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<_Accordion> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Align(
                      alignment: Alignment.centerLeft, // 🔥 PAKSA KIRI
                      child: widget.child,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
