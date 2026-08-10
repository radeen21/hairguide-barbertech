import 'qr_repository.dart';
import 'qr_session_entity.dart';

class ScanQrUseCase {
  final QrRepository repository;

  ScanQrUseCase(this.repository);

  Future<QrSessionEntity> execute(String qrCode) {
    return repository.scanQr(qrCode);
  }
}
