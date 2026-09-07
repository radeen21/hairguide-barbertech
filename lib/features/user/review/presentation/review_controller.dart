import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/features/user/review/data/review_remote_data_source.dart';

class ReviewController extends ChangeNotifier {
  final ReviewRemoteDataSource remote;

  bool isLoading = false;
  String? error;

  ReviewController(this.remote);

  Future<bool> submit({
    required String capsterId,
    required int rating,
    required String comment,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    debugPrint("SUBMIT REVIEW CONTROLLER");
    debugPrint("capsterId: $capsterId");
    debugPrint("rating   : $rating");
    debugPrint("comment  : $comment");

    try {
      await remote.submitReview(
        capsterId: capsterId,
        rating: rating,
        comment: comment,
      );

      return true;
    } catch (e) {
      error = "Gagal submit review";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
