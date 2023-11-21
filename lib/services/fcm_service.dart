
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pet_care_customer/network/firebase_helper.dart';

class FCMService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static const String key =
      'AAAAy1ardLo:APA91bEAEeCBAgL6Bbh0gE2skUmc0bO7IsQTNPD3QQnNe2Ak-GuNnOSWxH6ITP0h3wVl4gxa1w_pw_hrwztPGGhEOXFYiMHBXbCUoegJ7BN7LSfXRHLeNx_6Wcl_FluRqSliEMoXqf1M';

  static const _androidChannel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  static final _localNotifications = FlutterLocalNotificationsPlugin();

  static Future setUpFCM(String userId) async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _localNotifications.initialize(initializationSettings);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    messaging.onTokenRefresh.listen((token) async {
      await FirebaseHelper.updateToken(token, userId);
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(handleOnMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundMessage);

    initLocalNotification();
  }

  static Future handleBackgroundMessage(RemoteMessage? message) async {
    debugPrint('message background ${message!.data}');
  }

  static Future handleOnMessage(RemoteMessage message) async {
    final notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    debugPrint('message ${notification!.title}');
    // if (notification == null) return;

    if (notification != null && android != null && !kIsWeb) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
          ),
        ),
      );
    }
  }

  static Future<String?> getToken(String userId) async {
    String? token = await messaging.getToken();
    print('token : $token');
    await FirebaseHelper.updateToken(token ?? '', userId);
    return token;
  }

  static Future initLocalNotification() async {}
}
