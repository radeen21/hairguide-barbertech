// features/user/points/domain/points_repository.dart
import 'package:hairguide_barberpedia/features/user/homepage/points/domain/point_entity.dart';

abstract class PointsRepository {
  Future<PointsEntity> getPoints();
}
