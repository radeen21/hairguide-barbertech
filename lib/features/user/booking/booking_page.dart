import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Booking",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              /// 🖼️ ILLUSTRATION
              Opacity(
                opacity: 0.9,
                child: Image.asset("assets/logo_barbertech.png", height: 180),
              ),

              const SizedBox(height: 30),

              /// 📝 TITLE
              const Text(
                "Mau Booking Sekarang?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              /// 📄 DESCRIPTION
              const Text(
                "Silakan hubungi kami atau klik tombol booking untuk melanjutkan.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),

              const SizedBox(height: 32),

              /// 📞 CONTACT INFO
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // Icon(
                    //   Icons.email_outlined,
                    //   size: 18,
                    //   color: Color(0xFF20D6C7),
                    // ),
                    // SizedBox(width: 6),
                    // Text(
                    //   "booking@barberpedia.com",
                    //   style: TextStyle(color: Color(0xFF20D6C7), fontSize: 13),
                    // ),
                    SizedBox(width: 20),
                    Icon(
                      Icons.phone_outlined,
                      size: 18,
                      color: Color(0xFFF6AD03),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "0858 8888 7780",
                      style: TextStyle(color: Color(0xFFF6AD03), fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// ✅ BUTTON
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: booking action
                    debugPrint("📞 BOOKING CLICKED");
                    _callBooking();
                  },
                  icon: const Icon(Icons.phone_outlined),
                  label: const Text(
                    "Booking Sekarang",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6AD03),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _callBooking() async {
  final Uri phoneUri = Uri.parse("tel:081234567890");

  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    debugPrint("❌ Tidak bisa membuka dialer");
  }
}

}


