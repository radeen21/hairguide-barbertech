import 'package:dio/dio.dart';

class PointsRemoteDataSource {
  final Dio dio;

  PointsRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getPoints() async {
    final response = await dio.get("/points");
    return response.data;
  }
}
