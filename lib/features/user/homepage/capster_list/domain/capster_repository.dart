import 'capster_entity.dart';

abstract class CapsterRepository {
  Future<CapsterPage> getCapsters({String? cursor});
}

class CapsterPage {
  final List<CapsterEntity> items;
  final String? nextCursor;

  CapsterPage({
    required this.items,
    required this.nextCursor,
  });
}

