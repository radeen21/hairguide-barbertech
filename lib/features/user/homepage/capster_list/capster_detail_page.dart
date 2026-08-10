import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/core/dio_client.dart';
import 'package:hairguide_barberpedia/core/env/env_config.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/domain/capster_entity.dart';

class CapsterDetailPage extends StatefulWidget {
  final CapsterEntity capster;

  const CapsterDetailPage({super.key, required this.capster});

  @override
  State<CapsterDetailPage> createState() => _CapsterDetailPageState();
}

class _CapsterDetailPageState extends State<CapsterDetailPage> {
  final Map<String, Uint8List> _imageCache = {};

  String buildCapsterImageUrl(String photoPath) {
    final clean = photoPath.trim();

    if (clean.isEmpty) return "";
    if (clean.startsWith("http")) return clean;

    final fixedPath = clean.startsWith("/") ? clean.substring(1) : clean;

    return "${EnvConfig.baseUrl}/photos/$fixedPath";
  }

  Future<Uint8List> _loadImageWithAuth(String url) async {
    if (_imageCache.containsKey(url)) {
      return _imageCache[url]!;
    }

    final dio = DioClient.create();

    debugPrint("🖼️ LOAD DETAIL IMAGE = $url");

    final res = await dio.get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
      ),
    );

    final bytes = Uint8List.fromList(res.data);
    _imageCache[url] = bytes;

    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = buildCapsterImageUrl(widget.capster.photoUrl ?? "");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Detail Capster",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🖼️ IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FutureBuilder<Uint8List>(
                future: _loadImageWithAuth(imageUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 200,
                      color: Colors.grey[800],
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      ),
                    );
                  }

                  if (snapshot.hasError || snapshot.data == null) {
                    debugPrint("❌ DETAIL IMAGE ERROR = ${snapshot.error}");
                    return Image.asset(
                      "assets/banner_grooming.png",
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  }

                  return Image.memory(
                    snapshot.data!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            /// 👤 NAME
            Text(
              widget.capster.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            /// ⭐ RATING
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 18),
                const SizedBox(width: 4),
                Text(
                  "${widget.capster.rating} (${widget.capster.reviewsCount} reviews)",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _section(
              title: "Spesialisasi",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("• Fade & Beard Specialist",
                      style: TextStyle(color: Colors.white)),
                  Text("• Classic Cut Expert",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),

            _section(
              title: "Deskripsi",
              child: const Text(
                "Capster berpengalaman dengan fokus pada detail, "
                "kenyamanan, dan kepuasan pelanggan.",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
