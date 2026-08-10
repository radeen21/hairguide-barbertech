import 'package:flutter/material.dart';
import '../domain/scan_qr_usecase.dart';
import '../domain/qr_session_entity.dart';

class ScanController extends ChangeNotifier {
  final ScanQrUseCase useCase;

  ScanController(this.useCase);

  bool isLoading = false;
  QrSessionEntity? session;

  Future<void> scan(String qrCode) async {
    isLoading = true;
    notifyListeners();

    try {
      session = await useCase.execute(qrCode);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
