import 'dart:async';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextdoorpartner/models/walkthrough_model.dart';
import 'package:nextdoorpartner/ui/forgot_password.dart';
import 'package:nextdoorpartner/ui/get_started.dart';
import 'package:nextdoorpartner/ui/walkthrough.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/firebase_notification.dart';
import 'package:nextdoorpartner/util/local_notification.dart';
import 'package:nextdoorpartner/util/strings_en.dart';

import 'login.dart';

void main() {
  ///manage for IOS
  Crashlytics.instance.enableInDevMode = true;

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
  List<WalkThroughModel> walkThroughModelList;
  LocalNotifications localNotifications = LocalNotifications();
  void loadWalkThrough() {
    walkThroughModelList = List<WalkThroughModel>();
    walkThroughModelList.add(WalkThroughModel(
        AppTheme.primary_color,
        Strings.supportLocalBusiness,
        Strings.orderDailyEssentials,
        'walkthrough_1.png'));
    walkThroughModelList.add(WalkThroughModel(
        AppTheme.walkthrough_color_2,
        Strings.bookAppointments,
        Strings.listAppointments,
        'walkthrough_2.png'));
    walkThroughModelList.add(WalkThroughModel(AppTheme.walkthrough_color_3,
        Strings.bookServices, Strings.listServices, 'walkthrough_3.png'));
  }

  @override
  void initState() {
    super.initState();
    LocalNotifications.initialize();
    localNotifications.configureDidReceiveLocalNotificationSubject(context);
    localNotifications.configureSelectNotificationSubject(context);
    localNotifications.requestIOSPermissions();
    FirebaseNotifications().setUpFirebase(localNotifications);
    loadWalkThrough();
  }

  @override
  void dispose() {
    localNotifications.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'nunito',
      ),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
//        body: WalkThrough(
//          walkThroughModelList: walkThroughModelList,
//        ),
        body: GetStarted(),
      ),
    );
  }
}
