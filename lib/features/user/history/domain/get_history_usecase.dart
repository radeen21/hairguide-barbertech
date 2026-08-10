import 'package:hairguide_barberpedia/features/user/history/domain/history_entity.dart';
import 'package:hairguide_barberpedia/features/user/history/domain/history_repository.dart';

class GetHistoriesUseCase {
  final HistoryRepository repository;

  GetHistoriesUseCase(this.repository);

  Future<List<HistoryEntity>> call() {
    return repository.getHistories();
  }
}
