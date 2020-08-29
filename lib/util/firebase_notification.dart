import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nextdoorpartner/bloc/notification_bloc.dart';
import 'package:nextdoorpartner/models/notification_model.dart';
import 'package:nextdoorpartner/util/local_notification.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  LocalNotifications localNotifications;

  void setUpFirebase(LocalNotifications localNotifications) {
    this.localNotifications = localNotifications;
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessagingListeners();
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
      SharedPreferencesManager.getInstance().then((value) =>
          {value.setString(SharedPreferencesManager.firebaseToken, token)});
    });

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');
          NotificationBloc notificationBloc = NotificationBloc();
          notificationBloc.insertNotificationInDb(NotificationModel(
              title: 'Message', body: 'hello', receivedAt: '124rfx'));
          localNotifications.showNotification();
        },
        onResume: (Map<String, dynamic> message) async {
          print('on resume $message');
          NotificationBloc notificationBloc = NotificationBloc();
          notificationBloc.insertNotificationInDb(NotificationModel(
              title: 'Resume', body: 'hello', receivedAt: '124rfx'));
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('on launch $message');
          NotificationBloc notificationBloc = NotificationBloc();
          notificationBloc.insertNotificationInDb(NotificationModel(
              title: 'Launch', body: 'hello', receivedAt: '124rfx'));
        },
        onBackgroundMessage:
            Platform.isAndroid ? myBackgroundMessageHandler : null);
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    NotificationBloc notificationBloc = NotificationBloc();
    notificationBloc.insertNotificationInDb(NotificationModel(
        title: 'Background', body: 'hello', receivedAt: '124rfx'));
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print(data);
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print(notification);
    }
    return Future<void>.value();
    // Or do other work.
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
