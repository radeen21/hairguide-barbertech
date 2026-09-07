import 'package:hairguide_barberpedia/features/user/review/domain/review_repository.dart';
import 'review_remote_data_source.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<Map<String, dynamic>> submitReview({
    required String capsterId,
    required int rating,
    required String comment,
  }) {
    return remoteDataSource.submitReview(
      capsterId: capsterId,
      rating: rating,
      comment: comment,
    );
  }
}
