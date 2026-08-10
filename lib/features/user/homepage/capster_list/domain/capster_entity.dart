class CapsterEntity {
  final String id;
  final String name;
  final double rating;
  final int reviewsCount;
  final String photoUrl;

  CapsterEntity({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviewsCount,
    required this.photoUrl,
  });

  factory CapsterEntity.fromJson(Map<String, dynamic> json) {
    return CapsterEntity(
      id: json["id"],
      name: json["name"],
      rating: (json["rating"] ?? 0).toDouble(),
      reviewsCount: json["reviews_count"] ?? 0,
      photoUrl: json["photo_url"] ?? "",
    );
  }
}
