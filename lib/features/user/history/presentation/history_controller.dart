import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/features/user/history/domain/get_history_usecase.dart';
import 'package:hairguide_barberpedia/features/user/history/domain/history_entity.dart';

class HistoryController extends ChangeNotifier {
  final GetHistoriesUseCase getHistoriesUseCase;

  HistoryController(this.getHistoriesUseCase);

  bool isLoading = false;
  List<HistoryEntity> histories = [];

  Future<void> fetchHistories() async {
    try {
      isLoading = true;
      notifyListeners();

      histories = await getHistoriesUseCase();

      debugPrint("HISTORIES LOADED: ${histories.length}");
    } catch (e) {
      debugPrint("FETCH HISTORIES ERROR: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
