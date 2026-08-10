import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/core/di/service_locator.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/logout/usecase/logout_usecase.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/session/auth_session_repository.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final LogoutUseCase logoutUseCase;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.logoutUseCase,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    setState(() => _isLoggingOut = true);

    try {
      await widget.logoutUseCase.call();
      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logout gagal: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  const Text(
                    "Akun",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// PROFILE HEADER
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage("assets/profile_dummy.png"),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          widget.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// POINT CARD
                  _pointsCard(),

                  const SizedBox(height: 24),

                  /// MENU LIST
                  _profileListItem(
                    icon: Icons.person_outline,
                    title: "Akun",
                    desc: "Profil foto, nama, email, dan no. handphone",
                  ),
                  _divider(),

                  _profileListItem(
                    icon: Icons.settings_outlined,
                    title: "Pengaturan",
                    desc: "Pengaturan aplikasi Barberpedia",
                  ),
                  _divider(),

                  _profileListItem(
                    icon: Icons.help_outline,
                    title: "FAQ",
                    desc: "Pertanyaan umum tentang Barberpedia",
                  ),
                  _divider(),

                  _profileListItem(
                    icon: Icons.verified_user_outlined,
                    title: "Syarat dan Ketentuan",
                    desc: "Syarat dan ketentuan aplikasi Barberpedia",
                  ),

                  const SizedBox(height: 40),

                  /// LOGOUT
                  Center(
                    child: GestureDetector(
                      onTap: _handleLogout,
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),

        /// 🔥 LOADING OVERLAY (BLOCK INTERACTION)
        if (_isLoggingOut)
          Container(
            color: Colors.black.withOpacity(0.6),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
                strokeWidth: 4,
              ),
            ),
          ),
      ],
    );
  }

  Widget _profileListItem({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 26),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                desc,
                style: const TextStyle(color: Colors.white60, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Container(height: 1, color: Colors.white12),
    );
  }
}

Widget _pointsCard() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Image.asset(
              "assets/icon_element_container.png",
              fit: BoxFit.cover,
            ),
          ),

          // 🎯 CONTENT
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${locator<AuthSessionRepository>().getPoint()} pts",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Row(
                  children: [
                    Text(
                      "Tukarkan poin",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFFFFFFFF),
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
