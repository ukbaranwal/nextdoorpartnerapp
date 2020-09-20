import 'package:flutter/material.dart';
import 'package:nextdoorpartner/models/error_screen_model.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/util/app_theme.dart';

import '../util/strings_en.dart';

enum ErrorType { NO_INTERNET, SERVER_ERROR, PAGE_NOT_FOUND }

class ErrorScreen extends StatefulWidget {
  final ErrorType errorType;

  ErrorScreen({this.errorType});
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  ErrorScreenModel errorScreenModel;

  @override
  void initState() {
    super.initState();
    if (widget.errorType == ErrorType.NO_INTERNET) {
      errorScreenModel = ErrorScreenModel(
          Strings.errorScreenNoInternet,
          'assets/images/no_network.png',
          Strings.errorScreenNoInternetDetails,
          Strings.tryAgain);
    } else if (widget.errorType == ErrorType.PAGE_NOT_FOUND) {
      errorScreenModel = ErrorScreenModel(
          Strings.errorScreenNotFound,
          'assets/images/not_found.png',
          Strings.errorScreenNotFoundDetails,
          Strings.goBack);
    } else {
      errorScreenModel = ErrorScreenModel(
          Strings.errorScreenServerError,
          'assets/images/server_error.png',
          Strings.errorScreenServerErrorDetails,
          Strings.goBack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: CustomAppBar(),
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorScreenModel.title,
                style: TextStyle(
                    color: AppTheme.secondary_color,
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 30,
              ),
              Image.asset(
                errorScreenModel.imagePath,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  errorScreenModel.errorDetails,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppTheme.secondary_color,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                onPressed: () {
                  if (widget.errorType != ErrorType.NO_INTERNET) {
                    Navigator.pop(context);
                  }
                },
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: Text(
                  errorScreenModel.buttonText,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                ),
                color: AppTheme.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              SizedBox(
                height: 100,
              )
            ],
          )),
    );
  }
}
