import 'package:hairguide_barberpedia/features/capsters/takePicture/data/take_photo_api.dart';

class TakePhotoRepository {
  final TakePhotoApi api;
  TakePhotoRepository(this.api);

  Future<Map<String, dynamic>> upload(String path) async {
    final response = await api.uploadPhoto(path);
    return response.data;
  }
}
