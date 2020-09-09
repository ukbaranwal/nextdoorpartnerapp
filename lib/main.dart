import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextdoorpartner/models/vendor_model.dart';
import 'package:nextdoorpartner/ui/dashboard.dart';
import 'package:nextdoorpartner/ui/get_started.dart';
import 'package:nextdoorpartner/ui/logged_in_unverified.dart';
import 'package:nextdoorpartner/ui/splash_screen.dart';
import 'package:nextdoorpartner/ui/walkthrough.dart';
import 'package:nextdoorpartner/util/background_sync.dart';
import 'package:nextdoorpartner/util/database.dart';
import 'package:nextdoorpartner/util/firebase_notification.dart';
import 'package:nextdoorpartner/util/local_notification.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  ///manage for IOS
  Crashlytics.instance.enableInDevMode = false;

  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  LocalNotifications.initialize();
  runZoned(() {
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LocalNotifications localNotifications = LocalNotifications();
  SharedPreferences sharedPreferences;
  bool isVerified;

  @override
  void initState() {
    super.initState();
    LocalNotifications.initialize();
    localNotifications.configureDidReceiveLocalNotificationSubject(context);
    localNotifications.configureSelectNotificationSubject(context);
    localNotifications.requestIOSPermissions();
    FirebaseNotifications().setUpFirebase(localNotifications);
  }

  Future<bool> getStoredData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    bool isLoggedIn =
        sharedPreferences.getBool(SharedPreferencesManager.isLoggedIn) ?? false;
    isVerified =
        sharedPreferences.getBool(SharedPreferencesManager.isVerified) ?? false;
    if (!isLoggedIn) {
      sharedPreferences.setBool(SharedPreferencesManager.isLoggedIn, false);
    } else {
      vendorModelGlobal.getStoredData(sharedPreferences);
    }
    return isLoggedIn;
  }

  @override
  void dispose() {
    localNotifications.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'nunito',
      ),
      home: FutureBuilder(
        future: getStoredData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Splashscreen();
          } else {
            return snapshot.data
                ? (isVerified ? Dashboard() : UnverifiedLoggedIn())
                : WalkThrough();
          }
        },
      ),
    );
  }
}
