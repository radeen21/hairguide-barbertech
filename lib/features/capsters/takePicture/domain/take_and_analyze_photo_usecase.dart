import 'dart:io';

import 'package:hairguide_barberpedia/features/capsters/takePicture/domain/photo_repository.dart';

class TakeAndAnalyzePhotoUseCase {
  final PhotoRepository repository;

  TakeAndAnalyzePhotoUseCase(this.repository);

  Future<Map<String, dynamic>> execute(
    File file, {
    required String serviceId,
    String? serviceType,
    Map<String, dynamic>? addOnPayload,
  }) async {
    final uploadResponse = await repository.uploadPhoto(file);

    if (uploadResponse["code"] != 201) {
      throw Exception(uploadResponse["message"] ?? "Upload gagal");
    }

    final photoId = uploadResponse["data"]["id"] as String;

    if (serviceType != null && serviceType != "haircut") {
      final generateAddOnResponse =
          await repository.generateImageAddOn(
        photoId: photoId,
        addOn: addOnPayload!,
      );

      return {
        "upload": uploadResponse,
        "analyze": null,
        "generate": generateAddOnResponse,
      };
    }

    final analyzeResponse = await repository.analyzePhoto(
      photoId: photoId,
      serviceId: serviceId,
    );

    final recommendations =
        (analyzeResponse["data"]["recommendation"] as List<dynamic>? ?? [])
            .map<Map<String, dynamic>>(
              (e) => {
                "haircut_name": e["haircut_name"]?.toString() ?? "",
                "rating": e["rating"]?.toString() ?? "",
              },
            )
            .toList();

    final generateResponse = await repository.generateImageByName(
      photoId: photoId,
      recommendation: recommendations,
    );

    return {
      "upload": uploadResponse,
      "analyze": analyzeResponse,
      "generate": generateResponse,
    };
  }
}
