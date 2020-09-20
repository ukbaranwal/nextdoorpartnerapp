import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextdoorpartner/bloc/forgot_password_bloc.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/ui/loading_dialog.dart';
import 'package:nextdoorpartner/ui/login.dart';
import 'package:nextdoorpartner/ui/reset_password.dart';
import 'package:nextdoorpartner/ui/sign_up.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/custom_toast.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:nextdoorpartner/util/strings_en.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  ForgotPasswordBloc forgotPasswordBloc;
  TextEditingController emailTextEditingController = TextEditingController();
  FocusScopeNode emailFocusNode = FocusScopeNode();
  SharedPreferences sharedPreferences;
  bool showResetScreenLink = false;

  void checkForValidation() {
    if (!isValidEmail(emailTextEditingController.text)) {
      CustomToast.show(Strings.enterValidEmail, context);
      return;
    }
    forgotPasswordBloc.requestResetPin(emailTextEditingController.text);
  }

  void checkResetScreen() async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    if (sharedPreferences.getString(SharedPreferencesManager.email) != null) {
      setState(() {
        showResetScreenLink = true;
      });
    }
  }

  ///To Validate Email
  bool isValidEmail(String value) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
  }

  changeFocus(FocusScopeNode focusScopeNode) {
    focusScopeNode.unfocus();
    checkForValidation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 22,
                            color: AppTheme.secondary_color,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.08,
                          decoration: BoxDecoration(
                              color: AppTheme.primary_color,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(60))),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 20),
                        child: Text(
                          Strings.forgotPassword,
                          style: TextStyle(
                              color: AppTheme.secondary_color,
                              fontSize: 32,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.25),
                          height: MediaQuery.of(context).size.height * 0.45,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: AppTheme.primary_color,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 60,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Text(
                                    Strings.enterYourEmailToReset,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SignUpInputCard(
                                icon: Icons.email,
                                hintText: Strings.email,
                                textEditingController:
                                    emailTextEditingController,
                                textInputType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                isPassword: false,
                                focusNode: emailFocusNode,
                                onFieldSubmitted: changeFocus,
                              ),
                              showResetScreenLink
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ResetPassword(),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: Text(
                                            Strings.alreadyRequestedAPin,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              Expanded(child: SizedBox()),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Login(),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        Strings.backToLogin,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    padding: EdgeInsets.only(
                                        left: 20, right: 30, top: 8, bottom: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40)),
                                      color: AppTheme.secondary_color,
                                    ),
                                    alignment: Alignment.bottomRight,
                                    child: FlatButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: () {
                                        checkForValidation();
                                      },
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(60))),
                          child: Image.asset(
                            'assets/images/forgot_password.png',
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Color(0X00FFFFFF),
      builder: (context) {
        return LoadingDialog();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    forgotPasswordBloc = ForgotPasswordBloc();
    checkResetScreen();
    forgotPasswordBloc.forgotPasswordStream.listen((event) {
      if (event.loader == LOADER.SHOW) {
        showLoadingDialog();
      } else if (event.loader == LOADER.HIDE) {
        CustomToast.show(event.message, context);
        Navigator.pop(context);
      }
      if (event.actions == ApiActions.SUCCESSFUL) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPassword(),
          ),
        );
      }
    });
  }
}
