// features/user/points/presentation/points_controller.dart
import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/domain/get_point_usecase.dart';

class PointsController extends ChangeNotifier {
  final GetPointsUseCase useCase;

  PointsController(this.useCase);

  bool isLoading = false;
  int points = 0;

  Future<void> fetchPoints() async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await useCase();
      points = result.totalPoints;
    } catch (e) {
      debugPrint("❌ Get points error: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
