import 'package:dio/dio.dart';
import 'capster_history_model.dart';

class CapsterHistoryRemoteDataSource {
  final Dio dio;

  CapsterHistoryRemoteDataSource(this.dio);

  Future<List<CapsterHistoryModel>> fetchHistories() async {
    final response = await dio.get("/histories/capster");

    final items = response.data["data"]["items"] as List;

    return items
        .map((e) => CapsterHistoryModel.fromJson(e))
        .toList();
  }
}
