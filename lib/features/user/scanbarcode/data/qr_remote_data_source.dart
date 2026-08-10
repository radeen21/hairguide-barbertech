import 'package:dio/dio.dart';

class QrRemoteDataSource {
  final Dio dio;

  QrRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> scanQr(String qrCode) async {
    final response = await dio.post(
      "/qr/scan",
      data: {
        "qr_code": qrCode,
      },
    );

    return response.data;
  }
}
