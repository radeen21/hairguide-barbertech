import 'package:hairguide_barberpedia/features/capsters/customerRecord/domain/capster_history_entity.dart';

class CapsterHistoryModel {
  final String id;
  final String memberName;
  final String lastServiceType;
  final bool isMember;
  final int totalVisits;
  final DateTime? lastServedDate;
  final int transactionAmount;
  final String status; // 🔥 PROCESSING / DONE

  CapsterHistoryModel({
    required this.id,
    required this.memberName,
    required this.lastServiceType,
    required this.isMember,
    required this.totalVisits,
    required this.lastServedDate,
    required this.transactionAmount,
    required this.status,
  });

  factory CapsterHistoryModel.fromJson(Map<String, dynamic> json) {
    return CapsterHistoryModel(
      id: json["id"] ?? "",
      memberName: json["member"]?["full_name"] ?? "-",
      lastServiceType: json["last_service_type"] ?? "-",
      isMember: json["is_member"] ?? false,
      totalVisits: json["total_visits"] ?? 0,
      lastServedDate: json["last_served_date"] != null
          ? DateTime.tryParse(json["last_served_date"])
          : null,
      transactionAmount: json["transaction_amount"] ?? 0,

      // 🔥 INI YANG PENTING
      status: json["status"] ?? "UNKNOWN",
    );
  }

  CapsterHistoryEntity toEntity() {
    return CapsterHistoryEntity(
      id: id,
      memberName: memberName,
      lastServiceType: lastServiceType,
      isMember: isMember,
      totalVisits: totalVisits,
      lastServedDate: lastServedDate,
      transactionAmount: transactionAmount,
      status: status,
    );
  }
}
