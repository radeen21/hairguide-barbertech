import 'package:hairguide_barberpedia/features/user/homepage/capster_list/domain/capster_entity.dart';

class CapsterModel extends CapsterEntity {
  CapsterModel({
    required super.id,
    required super.name,
    required super.rating,
    required super.reviewsCount,
    required super.photoUrl,
  });

  factory CapsterModel.fromJson(Map<String, dynamic> json) {
    return CapsterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      photoUrl: json['photo_url'] as String? ?? "",
    );
  }
}
