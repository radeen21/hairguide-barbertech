import 'package:flutter/material.dart';

class StartServiceDialog extends StatefulWidget {
  final void Function(String phone) onSubmit;

  const StartServiceDialog({
    super.key,
    required this.onSubmit,
  });

  /// Helper biar gampang dipanggil
  static Future<void> show(
    BuildContext context, {
    required void Function(String phone) onSubmit,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => StartServiceDialog(onSubmit: onSubmit),
    );
  }

  @override
  State<StartServiceDialog> createState() => _StartServiceDialogState();
}

class _StartServiceDialogState extends State<StartServiceDialog> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 353,
        height: 224,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🏷 TITLE
              const Text(
                "Masukkan Nomor Telepon",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              /// 📱 INPUT
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Contoh: 08123456789",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.black,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const Spacer(),

              /// ▶️ BUTTON
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
                    final phone = _phoneController.text.trim();

                    if (phone.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Nomor telepon wajib diisi"),
                        ),
                      );
                      return;
                    }

                    Navigator.pop(context);
                    widget.onSubmit(phone);
                  },
                  child: const Text(
                    "Mulai",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
