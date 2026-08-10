import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/core/env/env_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HairGuideAddOnPage extends StatelessWidget {
  final String imageUrl;

  const HairGuideAddOnPage({
    super.key,
    required this.imageUrl,
  });

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("session_token");
  }

  String _resolveImageUrl() {
    // ✅ kalau sudah full url → pakai langsung
    if (imageUrl.startsWith("http")) {
      return imageUrl;
    }

    // ✅ pastikan tidak double slash
    final cleanPath =
        imageUrl.startsWith("/") ? imageUrl.substring(1) : imageUrl;

    return "${EnvConfig.baseUrl}/photos/$cleanPath";
  }

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = _resolveImageUrl();

    debugPrint("🖼️ IMAGE URL: $resolvedUrl");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Hair Guide Add-On"),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: FutureBuilder<String?>(
          future: _getToken(),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator(color: Colors.orange);
            }

            return Image.network(
              resolvedUrl,
              headers: {
                "Authorization": "Bearer ${snapshot.data}",
              },
              fit: BoxFit.contain,
              loadingBuilder: (_, child, loading) {
                if (loading == null) return child;
                return const CircularProgressIndicator(color: Colors.orange);
              },
              errorBuilder: (_, error, __) {
                debugPrint("❌ IMAGE ERROR: $error");
                return const Text(
                  "Gagal memuat gambar",
                  style: TextStyle(color: Colors.white70),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
