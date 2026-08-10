import 'package:hairguide_barberpedia/features/user/homepage/points/domain/voucher/voucher_entity.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/domain/voucher/voucher_repository.dart';
import 'voucher_remote_data_source.dart';

class VoucherRepositoryImpl implements VoucherRepository {
  final VoucherRemoteDataSource remote;

  VoucherRepositoryImpl(this.remote);

  @override
  Future<List<VoucherEntity>> getVouchers() {
    return remote.getVouchers();
  }
  
  @override
  Future<void> redeemVoucher(String voucherCode) {
    return remote.redeemVoucher(voucherCode);
  }

  
}
