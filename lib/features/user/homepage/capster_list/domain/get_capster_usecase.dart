import 'package:hairguide_barberpedia/features/user/homepage/capster_list/domain/capster_repository.dart';

class GetCapstersUseCase {
  final CapsterRepository repository;

  GetCapstersUseCase(this.repository);

  Future<CapsterPage> call({String? cursor}) {
    return repository.getCapsters(cursor: cursor);
  }
}
