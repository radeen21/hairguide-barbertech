class VoucherEntity {
  final String id;
  final String code;
  final int discountPercent;
  final DateTime validFrom;
  final DateTime validTo;
  final int pointsRequired;

  VoucherEntity({
    required this.id,
    required this.code,
    required this.discountPercent,
    required this.validFrom,
    required this.validTo,
    required this.pointsRequired,
  });

  factory VoucherEntity.fromJson(Map<String, dynamic> json) {
    return VoucherEntity(
      id: json["id"],
      code: json["code"],
      discountPercent: json["discount_percent"],
      validFrom: DateTime.parse(json["valid_from"]),
      validTo: DateTime.parse(json["valid_to"]),
      pointsRequired: json["points_required"],
    );
  }
}
