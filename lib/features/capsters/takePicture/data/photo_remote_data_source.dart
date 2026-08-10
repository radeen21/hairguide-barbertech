// lib/features/capsters/takePicture/data/photo_remote_data_source.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class PhotoRemoteDataSource {
  final Dio dio;

  PhotoRemoteDataSource(this.dio);

  void _logRequest(String method, String path, dynamic data) {
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    print("📤 [$method] ${dio.options.baseUrl}$path");
    print("🧾 Headers: ${dio.options.headers}");
    print("📦 Payload: $data");
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  }

  void _logResponse(Response response) {
    print("🟢 STATUS: ${response.statusCode}");
    print("📥 RESPONSE: ${response.data}");
  }

  void _logError(DioException e) {
    print("🔴 ERROR REQUEST");
    print("❌ STATUS: ${e.response?.statusCode}");
    print("❌ MESSAGE: ${e.message}");
    print("❌ RESPONSE DATA: ${e.response?.data}");
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  }

  // =========================
  // 📤 UPLOAD PHOTO
  // =========================
  Future<Map<String, dynamic>> uploadPhoto(File file) async {
    const path = "/photos";

    final formData = FormData.fromMap({
      "photo": await MultipartFile.fromFile(
        file.path,
        filename: file.path.split("/").last,
      ),
    });

    _logRequest("POST", path, {"photo": file.path});

    try {
      final response = await dio.post(path, data: formData);
      _logResponse(response);
      return response.data;
    } on DioException catch (e) {
      _logError(e);
      rethrow;
    }
  }

  // =========================
  // 🔍 ANALYZE PHOTO (FIXED)
  // =========================
  Future<Map<String, dynamic>> analyzePhoto({
  required String photoId,
  String? serviceId, // 👈 nullable
}) async {
  const path = "/analyze-photo";

  final payload = {
    "photo_id": photoId,
    if (serviceId != null) "service_id": serviceId,
  };

  _logRequest("POST", path, payload);

  try {
    final response = await dio.post(path, data: payload);
    _logResponse(response);
    return response.data;
  } on DioException catch (e) {
    _logError(e);
    rethrow;
  }
}


  // =========================
  // 🎨 GENERATE IMAGE BY NAME
  // =========================
  Future<Map<String, dynamic>> generateImageByName({
    required String photoId,
    required List<Map<String, dynamic>> recommendation,
  }) async {
    const path = "/generate-image/by-name";

    final payload = {
      "photo_id": photoId,
      "recommendation": recommendation,
    };

    _logRequest("POST", path, payload);

    try {
      final response = await dio.post(path, data: payload);
      _logResponse(response);
      return response.data;
    } on DioException catch (e) {
      _logError(e);
      rethrow;
    }
  }

  // =========================
  // ➕ GENERATE IMAGE ADD-ON
  // =========================
  Future<Map<String, dynamic>> generateImageAddOn({
    required String photoId,
    required Map<String, dynamic> addOn,
  }) async {
    const path = "/generate-image/add-on";

    final payload = {
      "photo_id": photoId,
      "add_on": addOn,
    };

    _logRequest("POST", path, payload);

    try {
      final response = await dio.post(path, data: payload);
      _logResponse(response);
      return response.data;
    } on DioException catch (e) {
      _logError(e);
      rethrow;
    }
  }

  // =========================
  // 🖼 GET PHOTO BY ID
  // =========================
  Future<Uint8List> getPhotoById(String photoId) async {
    final path = "/photos/$photoId";

    _logRequest("GET", path, null);

    try {
      final response = await dio.get(
        path,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data is List<int>) {
        return Uint8List.fromList(response.data);
      } else {
        throw Exception("Invalid response format from $path");
      }
    } on DioException catch (e) {
      _logError(e);
      rethrow;
    }
  }

  // =========================
  // 🌐 GET PHOTO BY URL
  // =========================
  Future<Uint8List> getPhotoByUrl(String url) async {
    final cleanUrl = url.startsWith("//")
        ? url.substring(2)
        : url.startsWith("/")
            ? url.substring(1)
            : url;

    final path = "/photos/$cleanUrl";

    _logRequest("GET", path, null);

    try {
      final response = await dio.get(
        path,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data is List<int>) {
        return Uint8List.fromList(response.data);
      } else {
        throw Exception("Invalid response format from generated photo url");
      }
    } on DioException catch (e) {
      _logError(e);
      rethrow;
    }
  }
}
