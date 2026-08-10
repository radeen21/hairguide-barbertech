import 'voucher_entity.dart';
import 'voucher_repository.dart';

class GetVouchersUseCase {
  final VoucherRepository repository;

  GetVouchersUseCase(this.repository);

  Future<List<VoucherEntity>> call() {
    return repository.getVouchers();
  }
}
