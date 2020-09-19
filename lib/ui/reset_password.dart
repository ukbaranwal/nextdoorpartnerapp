import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:nextdoorpartner/bloc/reset_password_bloc.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/ui/loading_dialog.dart';
import 'package:nextdoorpartner/ui/login.dart';
import 'package:nextdoorpartner/ui/sign_up.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/custom_toast.dart';
import 'package:nextdoorpartner/util/strings_en.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  ResetPasswordBloc resetPasswordBloc;
  TextEditingController pinTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  FocusScopeNode pinFocusNode = FocusScopeNode();
  FocusScopeNode passwordFocusNode = FocusScopeNode();
  ScrollController scrollController = ScrollController();

  void checkForValidation() {
    if (pinTextEditingController.text.length < 4) {
      CustomToast.show('password should be of at least 4 characters', context);
      return;
    } else if (passwordTextEditingController.text.length < 8) {
      CustomToast.show('password should be of at least 8 characters', context);
      return;
    }
    resetPasswordBloc.resetPassword(
        pinTextEditingController.text, passwordTextEditingController.text);
  }

  changeFocus(FocusScopeNode focusScopeNode) {
    focusScopeNode.unfocus();
    FocusScopeNode focusScopeNode2;
    if (focusScopeNode == pinFocusNode) {
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
    resetPasswordBloc = ResetPasswordBloc();
    resetPasswordBloc.resetPasswordStream.listen((event) {
      if (event.loader == LOADER.SHOW) {
        showLoadingDialog();
      } else if (event.loader == LOADER.HIDE) {
        Navigator.pop(context);
        CustomToast.show(event.message, context);
      }
      if (event.actions == ApiActions.SUCCESSFUL) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ),
            (route) => false);
      }
    });
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
                          Strings.resetPassword,
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
                              SignUpInputCard(
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.number,
                                icon: Icons.fiber_pin,
                                hintText: Strings.resetPin,
                                isPassword: false,
                                focusNode: pinFocusNode,
                                onFieldSubmitted: changeFocus,
                                textEditingController: pinTextEditingController,
                              ),
                              SignUpInputCard(
                                textInputAction: TextInputAction.done,
                                textInputType: TextInputType.text,
                                isPassword: true,
                                focusNode: passwordFocusNode,
                                icon: Icons.lock,
                                hintText: Strings.newPassword,
                                onFieldSubmitted: changeFocus,
                                textEditingController:
                                    passwordTextEditingController,
                              ),
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
                            'assets/images/reset_password.png',
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
}
