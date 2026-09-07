import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/capster_finish_service_page.dart';
import 'domain/capster_history_entity.dart';

class CapsterHistoryItem extends StatelessWidget {
  final CapsterHistoryEntity data;

  const CapsterHistoryItem({super.key, required this.data});

  bool get isDone => data.isDone;
  bool get isOnGoing => data.isProcessing;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            data.formattedDate,
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PHOTO
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/logo_barberpedia.png",
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "Total kunjungan : ${data.totalVisits}",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Row(
                          children: [
                            _badge(
                              text: data.isMember ? "Member" : "Non Member",
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 6),
                            _badge(
                              text: isDone ? "Completed" : "On Going",
                              color: isDone ? Colors.green : Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    Text(
                      data.memberName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 28, color: Colors.white12),

          _infoRow("Terakhir dilayani", data.formattedLastServed),
          const SizedBox(height: 6),
          _infoRow("Jenis terakhir service", data.lastServiceType),

          if (isOnGoing) ...[
            const SizedBox(height: 14),
            const Divider(color: Colors.white12),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6AD03),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CapsterFinishServicePage(
        historyId: data.id,
        customerName: data.memberName,
      ),
    ),
  );
                },
                child: const Text(
                  "Lanjut",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _badge({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
