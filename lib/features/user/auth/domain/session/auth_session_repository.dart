abstract class AuthSessionRepository {
  String? getUserId();
  String? getSessionToken();
  String? getRefreshToken();
  bool isLoggedIn();
  String? getRole();

  int getPoint();                    
  Future<void> savePoint(int point);  

  void setActiveServiceHasAddons(bool value);
  bool getActiveServiceHasAddons();

  Future<void> saveSession({
    required String userId,
    required String sessionToken,
    required String refreshToken,
    required DateTime sessionExpiresAt,
    required DateTime refreshExpiresAt,
    String? role,
    required int point,
  });

  Future<void> clearSession();
}
