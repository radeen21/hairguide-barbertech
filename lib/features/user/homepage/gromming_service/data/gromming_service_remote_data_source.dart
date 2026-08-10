import 'package:dio/dio.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/data/gromming_service_model.dart';

class GrommingServiceRemoteDataSource {
  // final Dio dio;

  // GrommingServiceRemoteDataSource(this.dio);

  // Future<List<GrommingServiceModel>> getServices() async {
  //   final response = await dio.get('/services');

  //   final List data = response.data['data'];
  //   return data.map((e) => GrommingServiceModel.fromJson(e)).toList();
  // }

  final Dio dio;

   GrommingServiceRemoteDataSource(this.dio);

  Future<List<Map<String, dynamic>>> getServices() async {
    final response = await dio.get("/services");
    return List<Map<String, dynamic>>.from(response.data["data"]);
  }
}
