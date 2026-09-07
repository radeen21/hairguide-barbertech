import 'package:dio/dio.dart';

abstract class StartServiceRemoteDataSource {
  Future<Map<String, dynamic>> startService({
    required String phoneNumber,
    required String serviceId,
    required String haircutName,
    required List<Map<String, dynamic>> addOns,
  });
}

class StartServiceRemoteDataSourceImpl
    implements StartServiceRemoteDataSource {
  final Dio dio;

  StartServiceRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> startService({
    required String phoneNumber,
    required String serviceId,
    required String haircutName,
    required List<Map<String, dynamic>> addOns,
  }) async {
    final body = {
      "phone_number": phoneNumber,
      "service_id": serviceId,
      "haircut_name": haircutName,
      "add_ons": addOns,
    };

    final response = await dio.post(
      "/histories/start",
      data: body,
    );

    return response.data;
  }
}
