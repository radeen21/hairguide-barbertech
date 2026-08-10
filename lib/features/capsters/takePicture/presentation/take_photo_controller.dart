import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/domain/take_and_analyze_photo_usecase.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/presentation/take_photo_state.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/session/auth_session_repository.dart';

class TakePhotoController extends ChangeNotifier {
  final TakeAndAnalyzePhotoUseCase useCase;
  final AuthSessionRepository sessionRepository;

  TakePhotoController({
    required this.useCase,
    required this.sessionRepository,
  });

  String get userId => sessionRepository.getUserId()!;
  String get role => sessionRepository.getRole() ?? "user";

  TakePhotoState state = TakePhotoInitial();

  Future<void> uploadPhoto({
    required String path,
    required String serviceId,
    String? serviceType,
    Map<String, dynamic>? addOnPayload,
  }) async {
    state = TakePhotoLoading();
    notifyListeners();

    try {
      debugPrint("👤 ROLE: $role");
      debugPrint("🧾 SERVICE ID: $serviceId");

      final result = await useCase.execute(
        File(path),
        serviceId: serviceId,
        serviceType: serviceType,
        addOnPayload: addOnPayload,
      );

      state = TakePhotoSuccess(
        uploadResponse: result["upload"],
        analyzeResponse: result["analyze"],
        generateResponse: result["generate"],
      );
    } catch (e) {
      state = TakePhotoError(e.toString());
    }

    notifyListeners();
  }
}
