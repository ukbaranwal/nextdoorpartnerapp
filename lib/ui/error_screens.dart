import 'package:flutter/material.dart';
import 'package:nextdoorpartner/models/error_screen_model.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/util/app_theme.dart';

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
          'No Internet Connection',
          'assets/images/no_internet.png',
          'Please check your connection again or check your wifi',
          'Try Again');
    } else if (widget.errorType == ErrorType.PAGE_NOT_FOUND) {
      errorScreenModel = ErrorScreenModel(
          'Page Not Found',
          'assets/images/not_found.png',
          'Looks like you have clicked on something that doesn\'t exist',
          'Go Back');
    } else {
      errorScreenModel = ErrorScreenModel(
          'Server Error',
          'assets/images/server_error.png',
          'Looks like something is broken. We are currently working on this issue',
          'Go Back');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Text(
                  errorScreenModel.buttonText,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
                color: AppTheme.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              )
            ],
          )),
    );
  }
}
