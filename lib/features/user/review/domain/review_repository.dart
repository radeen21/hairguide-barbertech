abstract class ReviewRepository {
  Future<Map<String, dynamic>> submitReview({
    required String capsterId,
    required int rating,
    required String comment,
  });
}
