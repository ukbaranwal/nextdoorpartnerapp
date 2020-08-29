import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/login.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:nextdoorpartner/util/strings_en.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnverifiedLoggedIn extends StatelessWidget {
  void signOut(BuildContext context) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    sharedPreferences.clear();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return Login();
      },
    ), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
//    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          Image.asset(
            'assets/images/unverified.png',
            width: MediaQuery.of(context).size.width * 0.9,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              Strings.welcomeUnverified,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
          Text(
            Strings.reSignIn,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          FlatButton(
            color: AppTheme.background_grey,
            onPressed: () {
              signOut(context);
            },
            child: Text(
              Strings.signOut,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
