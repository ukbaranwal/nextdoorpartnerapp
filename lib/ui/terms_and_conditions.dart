import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/strings_en.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../util/strings_en.dart';

class TermsAndConditions extends StatefulWidget {
  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            WebView(
              initialUrl: Strings.hostUrl + 'terms',
            ),
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10))),
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            )
          ],
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context, true);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                      color: AppTheme.secondary_color,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    Strings.acceptTerms,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context, false);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  margin: EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    Strings.goBack,
                    style: TextStyle(
                        color: AppTheme.secondary_color,
                        fontWeight: FontWeight.w800,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
