import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/domain/gromming_service_entity.dart';

abstract class GrommingServiceRepository {
  Future<List<GrommingServiceEntity>> getServices();
}
