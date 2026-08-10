import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/domain/voucher/get_voucher_usecase.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/domain/voucher/voucher_entity.dart';

class VoucherController extends ChangeNotifier {
  final GetVouchersUseCase useCase;

  VoucherController(this.useCase);

  bool isLoading = false;
  List<VoucherEntity> vouchers = [];
  String? error;

  Future<void> fetch() async {
    isLoading = true;
    notifyListeners();

    try {
      vouchers = await useCase.call();
      error = null;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
