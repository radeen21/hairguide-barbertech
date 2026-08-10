import 'package:hairguide_barberpedia/features/user/homepage/capster_list/domain/capster_repository.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/data/capster_model.dart';
import 'capster_remote_data_source.dart';

class CapsterRepositoryImpl implements CapsterRepository {
  final CapsterRemoteDataSource remote;

  CapsterRepositoryImpl(this.remote);

  @override
  Future<CapsterPage> getCapsters({String? cursor}) async {
    final response = await remote.getCapsters(cursor: cursor);
    final data = response["data"];

    final items = (data["items"] as List)
        .map((e) => CapsterModel.fromJson(e))
        .toList();

    return CapsterPage(
      items: items,
      nextCursor: data["next_cursor"],
    );
  }
}
