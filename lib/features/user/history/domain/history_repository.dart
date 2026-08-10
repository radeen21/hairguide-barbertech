import 'package:hairguide_barberpedia/features/user/history/domain/history_entity.dart';

abstract class HistoryRepository {
  Future<List<HistoryEntity>> getHistories();
}
