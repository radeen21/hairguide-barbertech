import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReviewRemoteDataSource {
  final Dio dio;

  ReviewRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> submitReview({
    required String capsterId,
    required int rating,
    required String comment,
  }) async {
    debugPrint("➡️ POST /reviews");
    debugPrint("REQUEST BODY:");
    debugPrint({
      "capster_id": capsterId,
      "rating": rating,
      "comment": comment,
    }.toString());

    try {
      final response = await dio.post(
        "/reviews",
        data: {
          "capster_id": capsterId,
          "rating": rating,
          "comment": comment,
        },
      );

      debugPrint("✅ RESPONSE [${response.statusCode}]");
      debugPrint(response.data.toString());

      return response.data;
    } on DioException catch (e) {
      debugPrint("❌ API ERROR");
      debugPrint("STATUS: ${e.response?.statusCode}");
      debugPrint("DATA: ${e.response?.data}");
      rethrow;
    }
  }
}
