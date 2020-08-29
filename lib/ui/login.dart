import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:nextdoorpartner/bloc/login_bloc.dart';
import 'package:nextdoorpartner/models/vendor_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/ui/forgot_password.dart';
import 'package:nextdoorpartner/ui/logged_in_unverified.dart';
import 'package:nextdoorpartner/ui/sign_up.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/custom_toast.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:nextdoorpartner/util/strings_en.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc loginBloc;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  FocusScopeNode emailFocusNode = FocusScopeNode();
  FocusScopeNode passwordFocusNode = FocusScopeNode();
  ScrollController scrollController = ScrollController();

  ///To Validate Email
  bool isValidEmail(String value) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
  }

  void login() async {
    showProgressDialog(context: context, loadingText: 'Loading');
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    print(androidDeviceInfo.id);
    loginBloc.doLogin(emailTextEditingController.text,
        passwordTextEditingController.text, androidDeviceInfo.id);
    loginBloc.loginStream.listen((data) {
      print(data.message);
      dismissProgressDialog();
      CustomToast.show(data.message, context);
      if (data.status == Status.SUCCESSFUL) {
        data.data.storeInSharedPreferences();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  data.data.isVerified ? Dashboard() : UnverifiedLoggedIn(),
            ),
            (route) => false);
      } else if (data.status == Status.UNSUCCESSFUL) {
      } else {}
    });
  }

  void checkForValidation() {
    if (!isValidEmail(emailTextEditingController.text)) {
      CustomToast.show('enter a valid email', context);
      return;
    } else if (passwordTextEditingController.text.length < 8) {
      CustomToast.show('password should be of at least 8 characters', context);
      return;
    }
    login();
  }

  @override
  void initState() {
    super.initState();
    loginBloc = LoginBloc();
  }

  changeFocus(FocusScopeNode focusScopeNode) {
    focusScopeNode.unfocus();
    FocusScopeNode focusScopeNode2;
    if (focusScopeNode == emailFocusNode) {
      focusScopeNode2 = passwordFocusNode;
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    } else {
      passwordFocusNode.unfocus();
      checkForValidation();
      return;
    }
    FocusScope.of(context).requestFocus(focusScopeNode2);
  }

  @override
  void dispose() {
    loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              controller: scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 22,
                                color: AppTheme.secondary_color,
                              ),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 20),
                        child: Text(
                          Strings.welcomeBack,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: AppTheme.secondary_color,
                              fontSize: 32,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: AppTheme.primary_color,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40))),
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(20),
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(60))),
                                child: Hero(
                                  tag: 'happy',
                                  child: Image.asset(
                                    'assets/images/happy.png',
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              SignUpInputCard(
                                focusNode: emailFocusNode,
                                onFieldSubmitted: changeFocus,
                                textEditingController:
                                    emailTextEditingController,
                                icon: Icons.email,
                                hintText: Strings.email,
                                textInputType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                              ),
                              SignUpInputCard(
                                focusNode: passwordFocusNode,
                                onFieldSubmitted: changeFocus,
                                textEditingController:
                                    passwordTextEditingController,
                                icon: Icons.lock,
                                hintText: Strings.Password,
                                textInputType: TextInputType.text,
                                isPassword: true,
                                textInputAction: TextInputAction.done,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ForgotPassword(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Text(
                                      Strings.forgotPasswordLogin,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignUp(),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        Strings.registration,
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
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
