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
  ///Enable it to record error in firebase crashlytics
  Crashlytics.instance.enableInDevMode = true;

  /// Pass all uncaught errors to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  ///Initialize LocalNotifications
  LocalNotifications.initialize();
  runZoned(() {
    runApp(MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'nunito',
        ),
        home: MyApp()));

    ///onError Will be called on every error to report error to firebase
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LocalNotifications localNotifications = LocalNotifications();
  SharedPreferences sharedPreferences;

  ///Boolean to check if vendor has been verified by Next Door
  bool isVerified;

  @override
  void initState() {
    LocalNotifications.initialize();
    localNotifications.configureDidReceiveLocalNotificationSubject(context);
    localNotifications.configureSelectNotificationSubject(context);
    localNotifications.requestIOSPermissions();

    ///Setup Firebase
    FirebaseNotifications(context).setUpFirebase(localNotifications);
    super.initState();
  }

  ///Function to Store data in global vendor model
  ///and also to check if user is logged in or is verified
  Future<bool> getStoredData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    bool isLoggedIn =
        sharedPreferences.getBool(SharedPreferencesManager.isLoggedIn) ?? false;
    isVerified =
        sharedPreferences.getBool(SharedPreferencesManager.isVerified) ?? false;
    if (!isLoggedIn) {
      sharedPreferences.setBool(SharedPreferencesManager.isLoggedIn, false);
    } else {
      ///Get All data stored in SharedPreferences
      vendorModelGlobal.getStoredData(sharedPreferences);
    }
    return isLoggedIn;
  }

  @override
  void dispose() {
    ///Lose the instance of local notifications
    localNotifications.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///Change color of Bottom or top Toolbar and bottombar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    return FutureBuilder(
      future: getStoredData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          ///Show splashscreen while loading
          return Splashscreen();
        } else {
          return snapshot.data

              ///If vendor is verified take him to dashboard or take it Unverified Page
              ? (isVerified ? Dashboard() : UnverifiedLoggedIn())

              ///If not logged in Take them to Walkthrough
              : WalkThrough();
        }
      },
    );
  }
}
