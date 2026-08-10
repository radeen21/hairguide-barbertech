import 'package:flutter/foundation.dart';
import 'package:hairguide_barberpedia/features/user/review/domain/review_repository.dart';

class SubmitReviewUseCase {
  final ReviewRepository repository;

  SubmitReviewUseCase(this.repository);

  /// Return true kalau sukses
  Future<bool> execute({
    required String capsterId,
    required int rating,
    required String comment,
  }) async {
    debugPrint("🧠 SubmitReviewUseCase.execute()");

    /// =====================
    /// VALIDATION
    /// =====================
    if (capsterId.isEmpty) {
      debugPrint("❌ capsterId kosong");
      throw Exception("Capster ID tidak valid");
    }

    if (rating < 1 || rating > 5) {
      debugPrint("❌ rating tidak valid: $rating");
      throw Exception("Rating harus antara 1 - 5");
    }

    if (comment.trim().isEmpty) {
      debugPrint("❌ comment kosong");
      throw Exception("Comment wajib diisi");
    }

    /// =====================
    /// CALL REPOSITORY
    /// =====================
    try {
      debugPrint("📡 CALL submitReview()");
      debugPrint({
        "capster_id": capsterId,
        "rating": rating,
        "comment": comment,
      }.toString());

      final result = await repository.submitReview(
        capsterId: capsterId,
        rating: rating,
        comment: comment,
      );

      debugPrint("✅ REVIEW SUCCESS");
      debugPrint(result.toString());

      return true;
    } catch (e, stack) {
      debugPrint("❌ REVIEW FAILED");
      debugPrint(e.toString());
      debugPrint(stack.toString());
      rethrow;
    }
  }
}
