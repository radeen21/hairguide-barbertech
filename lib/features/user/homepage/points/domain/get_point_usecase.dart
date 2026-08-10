// features/user/points/domain/get_points_usecase.dart
import 'package:hairguide_barberpedia/features/user/homepage/points/data/point_repository.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/domain/point_entity.dart';

class GetPointsUseCase {
  final PointsRepository repository;

  GetPointsUseCase(this.repository);

  Future<PointsEntity> call() {
    return repository.getPoints();
  }
}
