import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

  }

  /// Get FCM Token
  Future<String?> getToken() async {
    final token = await _messaging.getToken();
    return token;
  }

  /// Listen foreground messages
  void listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("   title: ${message.notification?.title}");
      debugPrint("   body : ${message.notification?.body}");
      debugPrint("   data : ${message.data}");
    });
  }

  /// Listen token refresh
  void listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint("FCM TOKEN REFRESHED: $newToken");
      // TODO: kirim token baru ke backend
    });
  }
}
