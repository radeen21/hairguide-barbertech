import 'package:dio/dio.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/domain/voucher/voucher_entity.dart';

abstract class VoucherRemoteDataSource {
  Future<List<VoucherEntity>> getVouchers();
  Future<void> redeemVoucher(String code);
}

class VoucherRemoteDataSourceImpl implements VoucherRemoteDataSource {
  final Dio dio;

  VoucherRemoteDataSourceImpl(this.dio);

  @override
  Future<List<VoucherEntity>> getVouchers() async {
    final response = await dio.get("/vouchers");

    final List list = response.data["data"] ?? [];

    return list.map((e) => VoucherEntity.fromJson(e)).toList();
  }

  @override
  Future<void> redeemVoucher(String code) async {
    await dio.post("/vouchers/redeem", data: {"code": code});
  }
}
