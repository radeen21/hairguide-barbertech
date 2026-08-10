import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/domain/gromming_service_entity.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/domain/gromming_service_usecase.dart';

class GrommingServicesController extends ChangeNotifier {
  final GetGroomingServicesUseCase getServicesUseCase;

  GrommingServicesController(this.getServicesUseCase);

  bool isLoading = false;
  List<GrommingServiceEntity> services = [];
  String? error;

  Future<void> fetchServices() async {
    try {
      isLoading = true;
      notifyListeners();

      services = await getServicesUseCase();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool shouldOpenHairGuide(GrommingServiceEntity s) => !s.isRecommended;
  bool shouldShowAddOn(GrommingServiceEntity s) => s.hasAddons;
}
