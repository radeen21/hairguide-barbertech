import 'package:hairguide_barberpedia/features/user/scanbarcode/domain/qr_session_entity.dart';

abstract class QrRepository {
  Future<QrSessionEntity> scanQr(String qrCode);
}
