import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CapsterRemoteDataSource {
  final Dio dio;

  CapsterRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getCapsters({String? cursor}) async {
    final response = await dio.get(
      "/capsters",
      queryParameters: cursor != null ? {"kursor": cursor} : null,
    );

    debugPrint("📥 CAPSTERS RESPONSE = ${response.data}");

    return response.data as Map<String, dynamic>;
  }
}
