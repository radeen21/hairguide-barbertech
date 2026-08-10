// features/user/points/data/points_repository_impl.dart
import 'package:hairguide_barberpedia/features/user/homepage/points/data/point_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/data/point_repository.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/domain/point_entity.dart';

class PointsRepositoryImpl implements PointsRepository {
  final PointsRemoteDataSource remote;

  PointsRepositoryImpl(this.remote);

  @override
  Future<PointsEntity> getPoints() async {
    final response = await remote.getPoints();

    return PointsEntity(
      totalPoints: response["data"]["total_points"] ?? 0,
    );
  }
}
