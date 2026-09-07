class CapsterHistoryEntity {
  final String id;
  final String memberName;
  final String lastServiceType;
  final bool isMember;
  final int totalVisits;
  final DateTime? lastServedDate;
  final int transactionAmount;
  final String status;

  CapsterHistoryEntity({
    required this.id,
    required this.memberName,
    required this.lastServiceType,
    required this.isMember,
    required this.totalVisits,
    required this.lastServedDate,
    required this.transactionAmount,
    required this.status,
  });

  bool get isProcessing => status == "PROCESSING";
  bool get isDone => status == "COMPLETED";

  String get serviceStatusLabel {
    if (isProcessing) return "On Going";
    if (isDone) return "Completed";
    return "-";
  }

  String get formattedDate {
    if (lastServedDate == null) return "-";
    final d = lastServedDate!;
    return "${d.day}/${d.month}/${d.year}";
  }

  String get formattedLastServed => formattedDate;
}
