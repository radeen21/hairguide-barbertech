import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/hairGuideDetail/domain/get_generated_photo_usecase.dart';
import 'recommendation_state.dart';

class RecommendationController extends ChangeNotifier {
  final GetGeneratedPhotosUseCase useCase;

  RecommendationController(this.useCase);

  RecommendationState state = RecommendationInitial();

  Future<void> load({
    required String userId,
    required String requestId,
  }) async {
    state = RecommendationLoading();
    notifyListeners();

    try {
      final photos = await useCase.execute(
        userId: userId,
        requestId: requestId,
      );
      state = RecommendationSuccess(photos);
    } catch (e) {
      state = RecommendationError(e.toString());
    }

    notifyListeners();
  }
}
