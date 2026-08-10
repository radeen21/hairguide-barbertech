import 'voucher_entity.dart';

abstract class VoucherRepository {
  Future<List<VoucherEntity>> getVouchers();
  Future<void> redeemVoucher(String voucherCode);
}
