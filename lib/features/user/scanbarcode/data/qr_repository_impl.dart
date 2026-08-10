import 'package:hairguide_barberpedia/features/user/scanbarcode/data/qr_session_model.dart';
import 'package:hairguide_barberpedia/features/user/scanbarcode/domain/qr_repository.dart';
import 'package:hairguide_barberpedia/features/user/scanbarcode/domain/qr_session_entity.dart';

import 'qr_remote_data_source.dart';

class QrRepositoryImpl implements QrRepository {
  final QrRemoteDataSource remote;

  QrRepositoryImpl(this.remote);

  @override
  Future<QrSessionEntity> scanQr(String qrCode) async {
    final response = await remote.scanQr(qrCode);

    if (response["code"] != 200) {
      throw Exception(response["message"] ?? "Scan QR gagal");
    }

    return QrSessionModel.fromJson(response["data"]);
  }
}
