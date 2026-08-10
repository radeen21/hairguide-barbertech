import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/core/di/service_locator.dart';
import 'package:hairguide_barberpedia/features/capsters/starService/presentation/start_service_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/dialog/start_service_dialog.dart';
import 'package:hairguide_barberpedia/features/user/homepage/gromming_service/domain/gromming_service_entity.dart';

class ServiceStartPage extends StatelessWidget {
  final GrommingServiceEntity service;

  const ServiceStartPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Service Detail",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// NAMA SERVICE
            Text(
              service.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            /// DESKRIPSI
            Text(
              service.description,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),

            const SizedBox(height: 24),

            /// INFO
            _infoRow("Harga", "Rp ${service.price}"),

            const Spacer(),

            /// BUTTON MULAI
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6AD03),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final controller = locator<StartServiceController>();

                  StartServiceDialog.show(
                    context,
                    onSubmit: (phone) async {
                      final success = await controller.startService(
                        phoneNumber: phone,
                        serviceId: service.id,
                        haircutName: service.name,
                        addOns: const [], // isi dari selection kalau ada
                      );

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Service berhasil dimulai"),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              controller.error ?? "Terjadi kesalahan",
                            ),
                          ),
                        );
                      }
                    },
                  );
                },

                child: const Text(
                  "Mulai Service",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LABEL (TOP)
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),

          const SizedBox(height: 6),

          /// VALUE (BOTTOM)
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
