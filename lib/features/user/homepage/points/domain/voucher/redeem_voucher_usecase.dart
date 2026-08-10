import 'package:hairguide_barberpedia/features/user/homepage/points/domain/voucher/voucher_repository.dart';

abstract class RedeemVoucherUseCase {
  Future<void> call(String voucherCode);
}

class RedeemVoucherUseCaseImpl implements RedeemVoucherUseCase {
  final VoucherRepository repository;

  RedeemVoucherUseCaseImpl(this.repository);

  @override
  Future<void> call(String voucherCode) {
    return repository.redeemVoucher(voucherCode);
  }
}
