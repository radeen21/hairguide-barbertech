import 'package:hairguide_barberpedia/features/capsters/takePicture/hairGuideDetail/data/model/generated_photo_model.dart';

abstract class RecommendationState {}

class RecommendationInitial extends RecommendationState {}

class RecommendationLoading extends RecommendationState {}

class RecommendationSuccess extends RecommendationState {
  final List<GeneratedPhoto> photos;

  RecommendationSuccess(this.photos);
}

class RecommendationError extends RecommendationState {
  final String message;

  RecommendationError(this.message);
}
