import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/domain/capster_entity.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/domain/get_capster_usecase.dart';

class CapsterController extends ChangeNotifier {
  final GetCapstersUseCase getCapstersUseCase;

  CapsterController(this.getCapstersUseCase);

  final List<CapsterEntity> capsters = [];
  bool isLoading = false;
  bool isLoadingMore = false;

  String? _nextCursor;
  bool _hasMore = true;

  Future<void> fetchCapsters() async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    final page = await getCapstersUseCase(cursor: null);

    capsters
      ..clear()
      ..addAll(page.items);

    _nextCursor = page.nextCursor;
    _hasMore = _nextCursor != null;

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !_hasMore) return;

    isLoadingMore = true;
    notifyListeners();

    final page = await getCapstersUseCase(cursor: _nextCursor);

    capsters.addAll(page.items);
    _nextCursor = page.nextCursor;
    _hasMore = _nextCursor != null;

    isLoadingMore = false;
    notifyListeners();
  }
}
