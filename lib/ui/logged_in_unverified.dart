import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/util/strings_en.dart';

class UnverifiedLoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
          )
        ],
      ),
    );
  }
}
