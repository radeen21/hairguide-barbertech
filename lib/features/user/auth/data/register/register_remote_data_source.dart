import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/core/dio_client.dart';

class RegisterRemoteDataSource {
  final Dio dioWithoutAuth = DioClient.createWithoutAuth();

  RegisterRemoteDataSource();

  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String phone,
    required String password,
    required String name,
    required String dob,
  }) async {
    const endpoint = "/auth/register";

    final payload = {
      "email": email,
      "phone": phone,
      "password": password,
      "name": name,
      "dob": dob,
    };

    try {
      debugPrint("");
      debugPrint("========== REGISTER REQUEST ==========");
      debugPrint("ENDPOINT : $endpoint");
      debugPrint("PAYLOAD  : $payload");
      debugPrint(" HEADERS  : ${dioWithoutAuth.options.headers}");
      debugPrint(" ====================================");
      debugPrint("");

      final response = await dioWithoutAuth.post(endpoint, data: payload);

      debugPrint("REGISTER SUCCESS RESPONSE:");
      debugPrint("STATUS : ${response.statusCode}");
      debugPrint("DATA   : ${response.data}");

      if (response.data is Map<String, dynamic>) {
        return response.data;
      }

      return {
        "success": true,
        "data": response.data,
      };
    } on DioException catch (e) {
      debugPrint("REGISTER ERROR");
      debugPrint("TYPE   : ${e.type}");
      debugPrint("MSG    : ${e.message}");
      debugPrint("STATUS : ${e.response?.statusCode}");
      debugPrint("DATA   : ${e.response?.data}");
      debugPrint("HEADER : ${e.response?.headers}");

      String errorMessage = "Register gagal";

      final errorData = e.response?.data;

      if (errorData is Map<String, dynamic>) {
        errorMessage = errorData["message"]?.toString() ?? "Register gagal";
      } else if (errorData is String && errorData.isNotEmpty) {
        errorMessage = errorData;
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      if (e.response?.statusCode == 502) {
        errorMessage =
            "Server sedang bermasalah. Silakan coba beberapa saat lagi.";
      }

      throw Exception(errorMessage);
    } catch (e) {
      debugPrint("UNKNOWN REGISTER ERROR: $e");
      throw Exception("Terjadi kesalahan saat register");
    }
  }
}