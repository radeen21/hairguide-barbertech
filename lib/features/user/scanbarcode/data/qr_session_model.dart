import 'package:hairguide_barberpedia/features/user/scanbarcode/domain/qr_session_entity.dart';

class QrSessionModel extends QrSessionEntity {
  QrSessionModel({
    required super.sessionId,
    required super.sessionCode,
    required super.status,
  });

  factory QrSessionModel.fromJson(Map<String, dynamic> json) {
    return QrSessionModel(
      sessionId: json["id"],
      sessionCode: json["session_code"],
      status: json["status"],
    );
  }
}
