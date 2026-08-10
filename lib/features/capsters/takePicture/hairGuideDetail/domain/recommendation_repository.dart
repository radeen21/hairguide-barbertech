import 'package:hairguide_barberpedia/features/capsters/takePicture/hairGuideDetail/data/model/generated_photo_model.dart';

abstract class RecommendationRepository {
  Future<List<GeneratedPhoto>> getGeneratedPhotos({
    required String userId,
    required String requestId,
  });
}
