import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextdoorpartner/bloc/notification_bloc.dart';
import 'package:nextdoorpartner/models/notification_model.dart';
import 'package:nextdoorpartner/ui/help_page.dart';
import 'package:nextdoorpartner/ui/new_order.dart';
import 'package:nextdoorpartner/ui/order_page.dart';
import 'package:nextdoorpartner/ui/pending_order.dart';
import 'package:nextdoorpartner/util/local_notification.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  LocalNotifications localNotifications;
  final String defaultTopic = 'default';
  final String vendorTopic = 'vendor';
  final BuildContext buildContext;

  FirebaseNotifications(this.buildContext);

  void setUpFirebase(LocalNotifications localNotifications) {
    this.localNotifications = localNotifications;
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessagingListeners();
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
      SharedPreferencesManager.getInstance().then(
        (value) => {
          value.setString(SharedPreferencesManager.firebaseToken, token),
        },
      );
    });

    _firebaseMessaging.subscribeToTopic(defaultTopic);
    _firebaseMessaging.subscribeToTopic(vendorTopic);

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');

          if (message['data']['screen'] == 'NEW_ORDER') {
            newOrderPageForeground(
                buildContext, int.tryParse(message['data']['id']));
          } else {
            localNotifications.showNotification(
                message['notification']['title'],
                message['notification']['body'],
                message['data'].toString());
          }
        },
        onResume: (Map<String, dynamic> message) async {
          print('on resume $message');
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('on launch $message');
          fcmMessageHandler(message, buildContext);
        },
        onBackgroundMessage:
            Platform.isAndroid ? myBackgroundMessageHandler : null);
  }

  void fcmMessageHandler(msg, context) {
    switch (msg['data']['screen']) {
      case 'NEW_ORDER':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                PendingOrder(int.tryParse(msg['data']['id']))));
        break;
      case 'ORDER':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                OrderPage(int.tryParse(msg['data']['id']))));
        break;
      default:
        break;
    }
  }

  void newOrderPageForeground(BuildContext context, int orderId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => NewOrder(orderId)));
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
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
